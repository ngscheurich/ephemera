defmodule Ephemera.Spotify.TracksWorker do
  @moduledoc """
  Maintains a list of recently played tracks and refreshes
  this list on a set interval.
  """

  use GenServer

  alias Ephemera.Spotify.GrantWorker

  @name SpotifyTracksWorker  
  @client Application.get_env(:ephemera, Ephemera.Spotify)[:client]
  @refresh_time 300_000

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def list do
    GenServer.call(@name, :list)
  end

  def refresh do
    GenServer.cast(@name, :refresh)
  end

  ## Server Callbacks

  def init(:ok) do
    schedule_refresh(0)
    {:ok, []}
  end

  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:refresh, state) do
    Process.send(self(), :refresh, [])
    {:noreply, state}
  end

  def handle_info(:refresh, state) do
    access_token = GrantWorker.access_token()

    case @client.get_recently_played(access_token, 3) do
      {:ok, tracks} ->
        schedule_refresh(@refresh_time)
        {:noreply, tracks}
      {:error, reason} ->
        raise inspect(reason)
    end
  end

  ## Helper Functions
  
  defp schedule_refresh(time) do
    Process.send_after(self(), :refresh, time)
  end
end
