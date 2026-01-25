defmodule Procs do
  def hello(count) do
    receive do
      {:quit} ->
        IO.puts("I'm outta here")

      {:add, n} ->
        hello(count + n)

      {:reset} ->
        hello(count = 0)

      msg ->
        IO.puts("#{count}: #{msg}")
        hello(count)
    end
  end
end
