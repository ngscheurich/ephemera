defmodule EphemeraWeb.Schema do
  use Absinthe.Schema
  import_types EphemeraWeb.Schema.ContentTypes

  alias EphemeraWeb.Resolvers

  query do
    @desc "Get recently played Spotify tracks"
    field :spotify_tracks, list_of(:spotify_track) do
      resolve &Resolvers.Content.spotify_recently_played/3
    end
  end

  subscription do
    @desc "Get notified when new recently played Spotify tracks are available"
    field :spotify_tracks_changed, list_of(:spotify_track) do
      resolve &Resolvers.Content.spotify_recently_played/3
    end
  end
end
