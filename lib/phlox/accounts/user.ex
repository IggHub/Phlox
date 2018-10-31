defmodule Phlox.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]
  alias Phlox.Accounts.Role
  alias Phlox.Content.Post

  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :username, :string


    timestamps()
    # virtual fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    #associations
    has_many :posts, Post
    belongs_to :role, Role
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :password, :password_confirmation])
    |> validate_required([:username, :email, :password, :password_confirmation])
    |> hash_password
  end

  defp hash_password(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_digest,  hashpwsalt(password))
    else
      changeset
    end
  end
end
