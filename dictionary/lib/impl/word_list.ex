defmodule Dictionary.Impl.WordList do
  @default_words "assets/words.txt"
  @word_list @default_words
    |> File.read!()
    |> String.split(~r/\n/, trim: true)

  @spec random_word() :: String.t()
  def random_word do
    @word_list
    |> Enum.random()
  end

  @spec random_word(words :: String.t()) :: String.t()
  def random_word(words) do
    words
    |> Enum.random()
  end

  @spec start() :: list(String.t())
  def start do
    @word_list
  end
end
