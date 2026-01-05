defmodule Procs do
  def hello(name) do
    Process.sleep(1000)
    IO.puts("Hello #{name}")
  end

  def new_proc(module_name, fun_name, values) do
    spawn(module_name, String.to_atom(fun_name), values)
  end
end
