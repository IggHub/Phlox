defmodule Phlox.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts" do
    field :body, :string
    field :title, :string

    timestamps()

    belongs_to :user, Phlox.Accounts.User
  end

  @doc false
  def changeset(post, attrs \\ %{}) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
