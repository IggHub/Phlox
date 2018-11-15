defmodule PhloxWeb.CommentHelperTest do
  use Phlox.DataCase

  alias Phlox.Content.Comment
  alias PhloxWeb.CommentHelper

  import Phlox.Factory

  setup do
    user        = insert(:user)
    post        = insert(:post, user: user)
    comment     = insert(:comment, post: post, approved: false)
    fake_socket = %{assigns: %{user: user.id}}

    {:ok, user: user, post: post, comment: comment, socket: fake_socket}
  end
end
