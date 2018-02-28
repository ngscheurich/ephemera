defmodule Ephemera.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(EphemeraWeb.Endpoint, []),
      supervisor(Absinthe.Subscription, [EphemeraWeb.Endpoint]),
      worker(Ephemera.Spotify.GrantWorker, []),
      worker(Ephemera.Spotify.TracksWorker, [])
    ]

    opts = [strategy: :one_for_one, name: Ephemera.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    EphemeraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
