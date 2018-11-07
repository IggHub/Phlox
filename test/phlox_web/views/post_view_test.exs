defmodule Phlox.PostViewTest do
  use PhloxWeb.ConnCase, async: true

  test "converts markdown to html" do
    {:ok, result, _error} = PhloxWeb.PostView.markdown("**bold me**")
    assert String.contains? result, "<strong>bold me</strong>"
  end

  test "leaves text with no markdown alone" do
    {:ok, result, _error} = PhloxWeb.PostView.markdown("nondescript me")
    assert String.contains? result, "<p>nondescript me</p>"
  end
end
