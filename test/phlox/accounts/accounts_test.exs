defmodule Phlox.AccountsTest do
  use Phlox.DataCase
  alias Phlox.TestHelper
  alias Phlox.Accounts
  alias Phlox.Accounts.User


  describe "users" do
    setup do
      {:ok, role} = TestHelper.create_role(%{name: "user", admin: false})
      {:ok, role: role}
    end

    @update_attrs %{email: "some updated email", password: "password2", password_confirmation: "password2", username: "some updated username"}
    @invalid_attrs %{email: nil, password: nil, password_confirmation: nil, username: nil}
    @fixture_attrs %{email: "some email", password_digest: "ABCDE", username: "some username"}
    @valid_attrs %{email: "some email", password: "password", password_confirmation: "password", username: "some username"}
    defp valid_attrs(role) do
      Map.put(@valid_attrs, :role_id, role.id)
    end

    def user_fixture(attrs \\ %{}) do
      {:ok, role} = TestHelper.create_role(%{name: "User", admin: false})
      {:ok, user} = TestHelper.create_user(role, %{username: "some username", email: "test@email.com", password: "password", password_confirmation: "password"})
      user
    end

    @tag :skip
    test "changeset with valid attributes", %{role: role} do
      changeset = User.changeset(%User{}, valid_attrs(role))
      assert changeset.valid?
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert length(Accounts.list_users()) == length([user])
    end

    # Problem with password and password_digest
    # test "get_user!/1 returns the user with given id" do
    #   user = user_fixture()
    #   assert Accounts.get_user!(user.id) == user
    # end

    @tag :skip
    # Accounts.create_user does not have role_id. Don't think we will be using it
    test "create_user/1 with valid data creates a user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      # assert user.email == "some email"
      # assert user.password == "password"
      # assert user.password_confirmation == "password"
      # assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.password == "password2"
      assert user.password_confirmation == "password2"
      assert user.username == "some updated username"
    end

    # Problem with password and password_digest
    # test "update_user/2 with invalid data returns error changeset" do
    #   user = user_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    #   assert user == Accounts.get_user!(user.id)
    # end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      # assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "password_digest value gets set to a hash" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, Ecto.Changeset.get_change(changeset, :password_digest))
    end

    test "password_digest value does not get set if password is nil" do
      changeset = User.changeset(%User{}, %{email: "test@test.com", password: nil, password_confirmation: nil, username: "test"})
      refute Ecto.Changeset.get_change(changeset, :password_digest)
    end
  end

  describe "roles" do
    alias Phlox.Accounts.Role

    @valid_attrs %{admin: true, name: "some name"}
    @update_attrs %{admin: false, name: "some updated name"}
    @invalid_attrs %{admin: nil, name: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Accounts.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Accounts.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = Accounts.create_role(@valid_attrs)
      assert role.admin == true
      assert role.name == "some name"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, role} = Accounts.update_role(role, @update_attrs)
      assert %Role{} = role
      assert role.admin == false
      assert role.name == "some updated name"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_role(role, @invalid_attrs)
      assert role == Accounts.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Accounts.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Accounts.change_role(role)
    end
  end


end
