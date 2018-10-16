defmodule PhloxWeb.PageController do
  use PhloxWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
