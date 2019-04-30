defmodule Pipe do
  def tap(data, func) do
    func.(data)
    data
  end

  def tap_async(data, func) do
    Task.start_link(fn ->
      func.(data)
    end)

    data
  end

  def tuple(item, tuple, index \\ -1) do
    case index do
      -1 -> Tuple.append(tuple, item)
      n -> Kernel.put_elem(tuple, item, n)
    end
  end

  def ok!({:ok, data}) do
    data
  end
end
