defmodule AppWeb.Schema do

  use Absinthe.Schema

  # Example data
  @user %{
    username: "Foo",
    password: "Bar",
    password_again: "Bar",
  }

  @desc "An user"
  object :user do
    field :username, :string
    field :password, :string
    field :password_again, :string
  end

  query do
    field :user, :user do
      resolve fn %{}, _ ->
        {:ok, @user }
      end
    end
  end

end
