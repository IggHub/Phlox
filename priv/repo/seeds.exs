# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Phlox.Repo.insert!(%Phlox.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Phlox.Repo
alias Phlox.Accounts.{Role, User}

role = %Role{}
  |> Role.changeset(%{name: "Admin", admin: true})
  |> Repo.insert!

admin = %User{}
  |> User.changeset(%{role_id: role.id, username: "admin", password: "test", password_confirmation: "test", email: "admin@email.com"})
  |> Repo.insert!
