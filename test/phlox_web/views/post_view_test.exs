defmodule Phlox.PostViewTest do
  use PhloxWeb.ConnCase, async: true

  test "converts markdown to html" do
    {:safe, result} = PhloxWeb.PostView.markdown("**bold me**")
    assert String.contains? result, "<strong>bold me</strong>"
  end

  test "leaves text with no markdown alone" do
    {:safe, result} = PhloxWeb.PostView.markdown("nondescript me")
    assert String.contains? result, "<p>nondescript me</p>"
  end
end
