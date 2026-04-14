defmodule Dictionary do
  alias Dictionary.Runtime.Server

  @opaque t :: Server.t()

  @spec start_link() :: {:ok, t}
  defdelegate start_link, to: Server

  @spec random_word(t) :: String.t()
  defdelegate random_word(words), to: Server

  # for a while commented due to lack of impl in server. 
  # @spec random_word() :: String.t()
  # defdelegate random_word, to: Server
end
