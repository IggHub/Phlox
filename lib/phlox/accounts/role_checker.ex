defmodule Phlox.Accounts.RoleChecker do
  alias Phlox.Repo
  alias Phlox.Accounts.Role

  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end
end
