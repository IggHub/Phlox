defmodule Phlox.Content.Comment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "comments" do
    field :approved, :boolean, default: false
    field :author, :string
    field :body, :string

    timestamps()
    belongs_to :post, Phlox.Content.Post
  end

  @doc false
  def changeset(comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:author, :body, :approved])
    |> validate_required([:author, :body, :approved])
  end
end
