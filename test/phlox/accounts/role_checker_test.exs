defmodule Phlox.Accounts.RoleCheckerTest do
  use Phlox.DataCase
  alias Phlox.Accounts.RoleChecker
  alias Phlox.TestHelper

  test "is_admin? is true when user has an admin role" do
    {:ok, role} = TestHelper.create_role(%{name: "Admin", admin: true})
    {:ok, user} = TestHelper.create_user(role, %{email: "admin@gmail.com", username: "test user admin", password: "test", password_confirmation: "test"})
    assert RoleChecker.is_admin?(user)
  end

  test "is_admin? is false when user does not have admin role" do
    {:ok, role} = TestHelper.create_role(%{name: "NonAdmin", admin: false})
    {:ok, user} = TestHelper.create_user(role, %{username: "aint admin", email: "not_admin@gmail.com", password: "test", password_confirmation: "test"})
    refute RoleChecker.is_admin?(user)
  end
end
