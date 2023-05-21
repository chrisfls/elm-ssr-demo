defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :graphql do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :graphql
    forward "/", Absinthe.Plug, schema: AppWeb.Schema
  end

  if Mix.env == :dev do
    forward "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: AppWeb.Schema,
      interface: :playground
  end
end
