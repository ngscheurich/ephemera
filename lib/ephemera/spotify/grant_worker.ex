defmodule Ephemera.Spotify.GrantWorker do
  @moduledoc """
  Maintains a valid Spotify authorization grant.
  """

  use GenServer

  @name SpotifyGrantWorker
  @client Application.get_env(:ephemera, Ephemera.Spotify)[:client]

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def access_token do
    GenServer.call(@name, :access_token) 
  end

  def refresh do
    GenServer.cast(@name, :refresh)
  end

  ## Server Callbacks

  def init(:ok) do
    schedule_refresh(0)
    {:ok, %{}}
  end

  def handle_call(:access_token, _from, state) do
    {:reply, state["access_token"], state}
  end

  def handle_cast(:refresh, state) do
    Process.send(self(), :refresh, [])
    {:noreply, state}
  end

  def handle_info(:refresh, state) do
    case @client.get_fresh_grant() do
      {:ok, grant} ->
        schedule_refresh(grant["expires_in"])
        {:noreply, grant}
      {:error, reason} ->
        raise inspect(reason)
    end
  end

  ## Helper Functions

  defp schedule_refresh(expires_in) do
    {time, _} =
      (expires_in * 0.9)
      |> Float.to_string
      |> Integer.parse

    Process.send_after(self(), :refresh, time * 1000)
  end
end
