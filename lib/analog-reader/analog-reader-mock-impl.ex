defmodule AnalogReaderMock do
  @behaviour AnalogReader

  @impl AnalogReader
  def init(_) do
    schedule()

    {:ok, nil}
  end

  def schedule do
    Process.send_after(self(), :input, 5000)
  end

  @doc """
  Randomly select one of the inputs and produce a random input change.
  Simulate :circuits_uart calls
  """
  def handle_info(:input, state) do
    input =
      0..3
      |> Enum.random()

    value = :random.uniform(1000)

    to_emit = {:circuits_uart, nil, "#{input}:#{value}\r\n"}

    Process.send(self(), to_emit, [])

    schedule()

    {:noreply, state}
  end
end
