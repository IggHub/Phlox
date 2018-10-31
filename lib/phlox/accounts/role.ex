defmodule Phlox.Accounts.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Phlox.Accounts.User

  schema "roles" do
    field :admin, :boolean, default: false
    field :name, :string

    timestamps()
    has_many :users, User
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:name, :admin])
    |> validate_required([:name, :admin])
  end
end
