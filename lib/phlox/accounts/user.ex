defmodule Phlox.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :username, :string


    timestamps()
    # virtual fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :password, :password_confirmation])
    |> validate_required([:username, :email, :password, :password_confirmation])
  end
end
