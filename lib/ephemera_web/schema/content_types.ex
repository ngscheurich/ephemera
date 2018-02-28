defmodule EphemeraWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  @desc "A track played via Spotify"
  object :spotify_track do
    field :name, :string
    field :artist, :string
    field :album, :string
    field :track_url, :string
    field :image_url, :string
    field :preview_url, :string
    field :played_at, :string
  end
end
