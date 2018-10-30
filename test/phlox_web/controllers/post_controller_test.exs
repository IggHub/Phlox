defmodule PhloxWeb.PostControllerTest do
  use PhloxWeb.ConnCase
  import Ecto
  alias Phlox.Repo
  alias Phlox.Accounts.User
  alias Phlox.Content.Post
  alias Phlox.Content

  @create_attrs %{body: "some body", title: "some title"}
  @update_attrs %{body: "some updated body", title: "some updated title"}
  @invalid_attrs %{body: nil, title: nil}

  alias Phlox.Accounts.User

  setup do
    {:ok, user} = create_user
    conn = build_conn()
    |> login_user(user)
    {:ok, conn: conn, user: user}
  end

  defp create_user do
    User.changeset(%User{}, %{email: "test@test.com", username: "test", password: "test", password_confirmation: "test"})
    |> Repo.insert
  end

  defp login_user(conn, user) do
    post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
  end

  def fixture(:post) do
    {:ok, post} = Content.create_post(@create_attrs)
    post
  end

  describe "index" do
    test "lists all posts", %{conn: conn, user: user} do
      conn = get conn, user_post_path(conn, :index, user)
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn, user: user} do
      conn = get conn, user_post_path(conn, :new, user)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = post conn, user_post_path(conn, :create, user), post: @create_attrs

      # assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == user_post_path(conn, :index, user)

      conn = get conn, user_post_path(conn, :index, user)
      assert html_response(conn, 200) =~ "Listing Posts"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = post conn, user_post_path(conn, :create, user), post: @invalid_attrs
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "show post" do
    test "show chosen resource", %{conn: conn, user: user} do
      post = build_post(user)
      conn = get conn, user_post_path(conn, :show, user, post)
      assert html_response(conn, 200) =~ "Show post"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, user: user} do
      post = build_post(user)
      conn = get conn, user_post_path(conn, :edit, user, post)
      
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, user: user} do
      post = build_post(user)
      conn = put conn, user_post_path(conn, :update, user, post), post: @update_attrs
      assert redirected_to(conn) == user_post_path(conn, :show, user, post)
      assert Repo.get_by(Post, @update_attrs)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      post = build_post(user)
      conn = put conn, user_post_path(conn, :update, user, post), post: %{"body" => nil}
      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, user: user} do
      post = build_post(user)
      conn = delete conn, user_post_path(conn, :delete, user, post)
      assert redirected_to(conn) == user_post_path(conn, :index, user)
      refute Repo.get(Post, post.id)
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end

  defp build_post(user) do
    changeset = user
    |> build_assoc(:posts)
    |> Post.changeset(@create_attrs)
    Repo.insert!(changeset)
  end
end
