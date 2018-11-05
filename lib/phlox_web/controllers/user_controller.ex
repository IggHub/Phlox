defmodule PhloxWeb.UserController do
  use PhloxWeb, :controller

  alias Phlox.Accounts
  alias Phlox.Accounts.User

  plug :authorize_admin when action in [:new, :create]
  plug :authorize_user when action in [:edit, :update, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  defp authorize_user(conn, _) do
    user = get_session(conn, :current_user)
    if user && (Integer.to_string(user.id) == conn.params["id"] || Phlox.Accounts.RoleChecker.is_admin?(user)) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that user!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end

  defp authorize_admin(conn, _) do
    user = get_session(conn, :current_user)
    if user && Phlox.Accounts.RoleChecker.is_admin?(user) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to create new users!")
      |> redirect(to: page_path(conn, :index))
      |> halt()
    end
  end
end
