defmodule Dictionary.Impl.WordList do
  @type t :: list(String)

  @spec word_list() :: t
  def word_list do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  @spec random_word() :: t
  def random_word do
    word_list()
    |> Enum.random()
  end

  @spec random_word(t) :: t
  def random_word(words) do
    words
    |> Enum.random()
  end
end
