defmodule Ephemera.Spotify.InMemoryClient do
  alias Ephemera.Spotify

  @behaviour Ephemera.Spotify.Client

  @doc false
  def get_recently_played(access_token, limit \\ 20) do
    tracks =
      Enum.reduce(1..limit, [], fn(x, acc) ->
        acc ++ [%Spotify.Track{name: "Track #{x}"}]
      end)

    {:ok, tracks}
  end

  @doc false
  def get_fresh_grant(refresh_token) do
    {:ok, "1a2b3c4d"}
  end
end
