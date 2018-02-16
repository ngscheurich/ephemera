defmodule EphemeraWeb.Router do
  use EphemeraWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EphemeraWeb do
    pipe_through :api
  end
end
