use Mix.Config

config :ephemera, EphemeraWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: Map.fetch!(System.get_env(), "APPLICATION_HOST"), port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: Map.fetch!(System.get_env(), "SECRET_KEY_BASE")

config :ephemera, Ephemera.Spotify,
  client_id: Map.fetch!(System.get_env(), "SPOTIFY_CLIENT_ID"),
  client_secret: Map.fetch!(System.get_env(), "SPOTIFY_CLIENT_SECRET"),
  refresh_token: Map.fetch!(System.get_env(), "SPOTIFY_REFRESH_TOKEN")

config :logger, level: :info
