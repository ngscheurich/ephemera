defmodule EphemeraWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :ephemera
  use Absinthe.Phoenix.Endpoint

  socket "/socket", EphemeraWeb.UserSocket

  plug Plug.Static,
    at: "/", from: :ephemera, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_ephemera_key",
    signing_salt: "V0RpjRpc"

  plug Corsica,
    origins: [~r{^http://localhost}],
    allow_headers: ["content-type"]

  plug EphemeraWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
