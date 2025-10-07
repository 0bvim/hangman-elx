defmodule Dictionary do
  @path "assets/words.txt"
  def word_list do
    words = File.read!(@path)
    String.split(words, ~r/\n/, trim: true)
  end

  def random_word do
    Enum.random(word_list())
  end
end
