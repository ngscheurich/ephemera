# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ephemera, EphemeraWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hTNE5mC/t/wc3bFS7kkw1cET4uqFKMwZyh+AL7AnppYU4OGgxiAKv8Ebt8jBY1rA",
  render_errors: [view: EphemeraWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Ephemera.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ephemera, Ephemera.Spotify, client: Ephemera.Spotify.HTTPClient

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
