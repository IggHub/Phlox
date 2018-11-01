defmodule PhloxWeb.LayoutViewTest do
  use PhloxWeb.ConnCase, async: true
  alias Phlox.TestHelper
  alias PhloxWeb.LayoutView
  alias Phlox.Accounts.User
  alias Phlox.Repo

  setup do
    {:ok, role} = TestHelper.create_role(%{name: "Some Role", admin: false})
    {:ok, user} = TestHelper.create_user(role, %{username: "Test User", email: "test@email.com", password: "password", password_confirmation: "password"})
    {:ok, conn: build_conn(), user: user}
  end

  test "current user returns the user in the session", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
    assert LayoutView.current_user(conn)
  end

  test "current user returns nothing if there is no user in the session", %{conn: conn, user: user} do
    conn = delete conn, session_path(conn, :delete, user)
    refute LayoutView.current_user(conn)
  end

  test "deletes user session", %{conn: conn, user: user} do
    conn = delete conn, session_path(conn, :delete, user)
    refute get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Signed out successfully!"
    assert redirected_to(conn) == page_path(conn, :index)
  end
end
