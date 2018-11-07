defmodule Phlox.Factory  do
  use ExMachina.Ecto, repo: Phlox.Repo

  alias Phlox.Accounts.{Role, User}
  alias Phlox.Content.Post

  def role_factory do
    %Role{
      name: sequence(:name, &"Test Role #{&1}"),
      admin: false
    }
  end

  def user_factory do
    %User{
      username: sequence(:username, &"User #{&1}"),
      email: "test@test.com",
      password: "test1234",
      password_confirmation: "test1234",
      password_digest: Comeonin.Bcrypt.hashpwsalt("test1234"),
      role: build(:role)
    }
  end

  def post_factory do
    %Post{
      title: "Some Post",
      body: "Some Post Body",
      user: build(:user)
    }
  end
end
