defmodule PhloxWeb.PostView do
  use PhloxWeb, :view

  def markdown(body) do
    body
    |> Earmark.to_html
    |> raw
  end
end
