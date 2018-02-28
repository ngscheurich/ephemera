defmodule Ephemera.Spotify.HTTPClient do
  @moduledoc """
  Provides functions for interfacing with Spotify’s web API. 
  """

  alias Ephemera.Spotify
  alias Spotify.HTTPClient
  alias Spotify.Track

  @behaviour Spotify.Client

  @config Application.get_env(:ephemera, Ephemera.Spotify)

  @client_id @config[:client_id]
  @client_secret @config[:client_secret]
  @refresh_token @config[:refresh_token]
  @base_url "https://api.spotify.com/v1"

  def info do
    IO.inspect @config
  end

  @doc """
  `GET`s the authenticated user’s most recently played tracks, optionally
  using the `limit` parameter.

  Returns `{:ok, tracks}` if successful, otherwise `{:error, reason}`.

  * `limit` - an optional integer describing how many tracks to request

  ## Examples

    iex> get_recently_played(3)
    {:ok, [%{}Track]}

    iex> get_recently_played(3)
    {:error, "Endpoint was unresponsive"}

  """
  @spec get_recently_played(String.t, integer) :: {:ok, list(Track.t)} | {:error, term}
  def get_recently_played(access_token, limit \\ 20) do
    endpoint ="#{@base_url}/me/player/recently-played"
    headers = [{"Authorization", "Bearer #{access_token}"}]

    case HTTPoison.get(endpoint, headers, params: [limit: limit]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body = Poison.decode!(body)
        tracks =
          body["items"]
          |> Enum.map(fn(item) -> Track.from_api(item) end)

        {:ok, tracks}
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        body =
          body
          |> Poison.decode!()
          |> Map.put("status_code", code)
          {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
  Exchanges the configured `spotify_refresh_token` for a new authorization
  grant. The `spotify_refresh_token` should be configured like:

  `config :ephemera, spotify_refresh_token: "1a2b3c"`

  Returns `{:ok, grant}` if successful, otherwise `{:error, reason}`.

  ## Examples

    iex> get_fresh_grant()
    {:ok, [%{}Spotify.Grant]}

    iex> get_fresh_grant()
    {:error, "Token was invalid"}

  """
  @spec get_fresh_grant :: Spotify.Grant.t
  def get_fresh_grant do
    endpoint = "https://accounts.spotify.com/api/token"
    headers = [
      basic_auth_header(),
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    case HTTPoison.post(endpoint, refresh_grant_body(), headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Poison.decode!(body)}
      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        {:error,
          body
          |> Poison.decode!()
          |> Map.put("status_code", code)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc false
  @spec basic_auth_header :: {String.t, String.t}
  defp basic_auth_header do
    client_tag = Base.encode64("#{@client_id}:#{@client_secret}")
    {"Authorization", "Basic #{client_tag}"}
  end

  @doc false
  @spec refresh_grant_body :: String.t
  defp refresh_grant_body do
    %{
      grant_type: "refresh_token",
      refresh_token: @refresh_token
    }
    |> URI.encode_query()
  end
end
