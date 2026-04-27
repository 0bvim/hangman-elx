defmodule Chain do
  defstruct(
    next_node: nil,
    count: 10000
  )

  def start_link(next_node) do
    spawn_link(Chain, :message_loop, [%Chain{next_node: next_node}])
    |> Process.register(:chainer)
  end

  def message_loop(%{count: 0}) do
    IO.puts("done")
  end

  def message_loop(state) do
    receive do
      {:trigger, list} ->
        send({:chainer, state.next_node}, {:trigger, [node() | list]})
    end

    message_loop(%{state | count: state.count - 1})
  end
end


# commented code to keep debugs messages that I use to figure out what's going on
# when I try to debug the chain
# def start_link(next_node) do
#   IO.puts "from start_link #{inspect(next_node)}"
#   spawn_link(Chain, :message_loop, [%Chain{next_node: next_node}])
#   |> Process.register(:chainer)
#   IO.puts "from start_link registered chainer #{inspect(:chainer)}"
#   IO.puts "from start_link registered next_node #{inspect(next_node)}"
# end

# def message_loop(%{count: 0}) do
#   IO.puts("done")
# end

# def message_loop(state) do
#   IO.puts "from state message loop #{inspect(state.count)}"
#   receive do
#     {:trigger, list} ->
#       IO.inspect(list, label: "list")
#       IO.inspect(node(), label: "node")
#       IO.inspect(state.next_node, label: "next_node")
#       :timer.sleep(500)
#       send({:chainer, state.next_node}, {:trigger, [node() | list]})
#   end

#   message_loop(%{state | count: state.count - 1})
# end