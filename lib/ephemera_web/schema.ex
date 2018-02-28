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
end
