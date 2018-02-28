defmodule Ephemera.Spotify.Grant do
  @moduledoc """
  Defines an authorization grant returned by the Spotify web API.
  
  * `access_token` - The string that can be used to authenticate API requests
  * `expires_in` - An integer representing the number of seconds until the `access_token` expires
  * `scope` - The string representing the scope(s) granted
  * `token_type` - The string describing the type of token returned
  """

  @type t :: %Ephemera.Spotify.Grant{}
  defstruct [:access_token, :expires_in, :scope, :token_type]
end
