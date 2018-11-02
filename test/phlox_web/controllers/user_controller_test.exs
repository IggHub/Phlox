defmodule PhloxWeb.UserControllerTest do
  use PhloxWeb.ConnCase
  alias Phlox.TestHelper
  alias Phlox.Accounts.Role
  alias Phlox.TestHelper
  alias Phlox.Accounts


  @create_attrs %{email: "some email", password: "password", password_confirmation: "password", username: "some username"}
  @update_attrs %{email: "some updated email", password: "password", password_confirmation: "password", username: "some updated username"}
  @invalid_attrs %{email: nil, password_digest: nil, username: nil}

  def fixture(:user) do
    {:ok, role} = TestHelper.create_role(%{name: "some role", admin: false})
    {:ok, user} = TestHelper.create_user(role, %{username: "some user", email: "email@gmail.com", password: "password", password_confirmation: "password"})
    user
  end

  setup do
    {:ok, user_role}     = TestHelper.create_role(%{name: "user", admin: false})
    {:ok, nonadmin_user} = TestHelper.create_user(user_role, %{email: "nonadmin@test.com", username: "nonadmin", password: "test", password_confirmation: "test"})

    {:ok, admin_role}    = TestHelper.create_role(%{name: "admin", admin: true})
    {:ok, admin_user}    = TestHelper.create_user(admin_role, %{email: "admin@test.com", username: "admin", password: "test", password_confirmation: "test"})

    {:ok, conn: build_conn(), admin_role: admin_role, user_role: user_role, nonadmin_user: nonadmin_user, admin_user: admin_user}
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get conn, user_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form for new resources", %{conn: conn, admin_user: admin_user} do
      conn = conn
      |> login_user(admin_user)
      |> get(user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    @tag :skip
    test "redirects to show when data is valid", %{conn: conn, role: role, user: user} do
      conn = post conn, user_path(conn, :create), user: @create_attrs #missing role?

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_path(conn, :show, id)

      conn = get conn, user_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get conn, user_path(conn, :edit, user)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @update_attrs
      assert redirected_to(conn) == user_path(conn, :show, user)

      conn = get conn, user_path(conn, :show, user)
      assert html_response(conn, 200) =~ "some updated email"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user, role: role} do
      conn = delete conn, user_path(conn, :delete, user)
      assert redirected_to(conn) == user_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, user_path(conn, :show, user)
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
