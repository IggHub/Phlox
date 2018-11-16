defmodule PhloxWeb.CommentChannelTest do
  use PhloxWeb.ChannelCase

  alias PhloxWeb.CommentChannel
  alias Phlox.Factory

  setup do
    # why not user = insert(:user) and why alias Phlox.Factory instead of import Phlox.Factory?
    user = Factory.create(:user)
    post = Factory.create(:post, user: user)
    comment = Factory.create(:comment, post: post, approved: false)

    {:ok, _, socket} = socket("user_id", %{user: user.id})
    |> subscribe_and_join(CommentChannel, "comments:#{post.id}")

    {:ok, socket: socket, post: post, comment: comment}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end

  test "CREATED_COMMENT broadcasts to comments:*", %{socket: socket, post: post} do
    push socket, "CREATED_COMMENT", %{"body" => "Test Post", "author" => "Test Author", "postId" => post.id}
    expected = %{"body" => "Test Post", "author" => "Test Author"}

    assert broadcast "CREATED_COMMENT", expected
  end
end
