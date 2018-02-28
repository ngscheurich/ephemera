defmodule EphemeraWeb.Resolvers.Content do
  alias Ephemera.Spotify.TracksWorker

  def spotify_recently_played(_parent, _args, _resolution) do
    {:ok, TracksWorker.list()}
  end
end
