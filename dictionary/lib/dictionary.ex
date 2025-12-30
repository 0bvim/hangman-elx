defmodule Dictionary do

  alias Dictionary.Impl.WordList

  @opaque wordlist :: list(String.t())

  @spec start() :: wordlist()
  defdelegate start, to: WordList

  @spec random_word(binary()) :: binary()
  defdelegate random_word(words), to: WordList

  @spec random_word() :: String.t()
  defdelegate random_word, to: WordList

end
