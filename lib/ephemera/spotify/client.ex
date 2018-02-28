defmodule Ephemera.Spotify.Client do
  @modeuldoc """
  This module defines an explicit contract to which all modules
  that act as consumers of the Spotify web API should adhere to.
  """

  alias Ephemera.Spotify.Track

  @callback get_recently_played(access_token :: String.t, integer()) :: {:ok, list(Track.t)} | {:error, term}
  @callback get_recently_played(access_token :: String.t) :: {:ok, list(Track.t)} | {:error, term}
  @callback get_fresh_grant :: {:ok, map} | {:error, term}
end
