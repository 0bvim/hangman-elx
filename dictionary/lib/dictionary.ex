defmodule Dictionary do
  @path "assets/words.txt"
  @word_list @path
    |> File.read!()
    |> String.split(~r/\n/, trim: true)

  def random_word do
    @word_list
    |> Enum.random()
  end
end
