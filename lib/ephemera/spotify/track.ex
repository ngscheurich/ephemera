defmodule Ephemera.Spotify.Track do
  @moduledoc """
  Defines a track played via Spotify.
  
  * `name` - The track’s name as a string
  * `artist` - The artist’s name as a string
  * `album` - The album’s name as a string
  * `track_url` - The tracks’s Spotify URL as a string
  * `image_url` - The URL as a string for the track’s artwork
  * `preview_url` - The URL as a string to Spotify’s sample of the track
  * `played_at` - A UTC datetime describing when the track was played
  """

  alias __MODULE__

  @type t :: %Ephemera.Spotify.Track{}
  defstruct [
    :name,
    :artist,
    :album,
    :track_url,
    :image_url,
    :preview_url,
    :played_at
  ]

  @doc """
  Given an item returned by the Spotify web API, returns a
  valid `Track` struct.

  ## Examples
  
    iex> from_api_item("")

  """
  def from_api(item) do
    track = item["track"]

    %Track{
      name: track["name"],
      artist: List.first(track["artists"])["name"],
      album: track["album"]["name"],
      track_url: track["external_urls"]["spotify"],
      image_url: List.first(track["album"]["images"])["url"],
      preview_url: track["preview_url"],
      played_at: item["played_at"]
    }
  end
end
