defmodule Phlox.Repo.Migrations.AddRoleIdToUsers do
  use Ecto.Migration

  def change do
    alter table :users do
      add :role_id, references(:roles)
    end
  end
end
