defmodule PhloxWeb.PostView do
  use PhloxWeb, :view

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end
end
