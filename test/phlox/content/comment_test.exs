defmodule Phlox.Content.CommentTest do
  import Phlox.Factory

  use Phlox.DataCase

  test "creates a comment associated with a post" do
    comment = insert(:comment)
    assert comment.post_id
  end
end
