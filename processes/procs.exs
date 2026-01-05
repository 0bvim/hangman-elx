defmodule Procs do
  def hello(name) do
    Process.sleep(1000)
    IO.puts("Hello #{name}")
  end

  @doc """
  To use it, you can provide an anonymous function or
  &Mod.fun/arity to capture a remote function, such as &Enum.map/2
  """
  def new_proc(mod, fun_name, values) do
    spawn(mod, String.to_atom(fun_name), values)
  end
end
