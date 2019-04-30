defmodule AnalogReader do
  @callback init(opts :: Keyword.t()) :: {:ok, term}

  use GenServer
  require Logger

  @args Application.get_env(:taocupao_app_nerves, __MODULE__)

  def start_link(_args, opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, @args, opts)
  end

  def init(args) do
    impl = Keyword.fetch!(args, :implementation)

    {:ok, priv} = impl.init(args)
    {:ok, %{impl: impl, priv: priv}}
  end

  def handle_info({:circuits_uart, _, {:partial, _data}}, uart) do
    Logger.info("Received partial data, ignoring...")

    {:noreply, uart}
  end

  def handle_info({:circuits_uart, _, data}, uart) do
    [input, value] =
      Regex.run(~r/^(\d*):(\d*)/, data)
      |> Enum.drop(1)
      |> Enum.map(&String.to_integer(&1))

    Tracker.set_value(input, value)

    {:noreply, uart}
  end

  def handle_info(message, state) do
    state.impl.handle_info(message, state)
  end

  def terminate(reason, _state) do
    IO.inspect(["terminated", reason])
  end
end
