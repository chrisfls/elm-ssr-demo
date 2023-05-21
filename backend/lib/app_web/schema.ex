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
    field :username, non_null(:string)
    field :password, non_null(:string)
    field :password_again, non_null(:string)
  end

  query do
    field :user, :user do
      resolve fn %{}, _ ->
        {:ok, @user }
      end
    end
  end

end
