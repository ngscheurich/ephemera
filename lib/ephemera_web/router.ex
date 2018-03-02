defmodule EphemeraWeb.Router do
  use EphemeraWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: EphemeraWeb.Schema

    forward "/", Absinthe.Plug,
      schema: EphemeraWeb.Schema
  end
end
