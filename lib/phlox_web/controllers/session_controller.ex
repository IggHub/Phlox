defmodule PhloxWeb.SessionController do
  use PhloxWeb, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
end
