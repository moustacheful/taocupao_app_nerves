defmodule Health do
  use GenServer
  require Logger

  @target Mix.target()

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule()
    {:ok, state}
  end

  def handle_info(:heartbeat, state) do
    now = System.system_time(:millisecond)

    Firebase.put("/health/heartbeat_#{@target}.json", Integer.to_string(now))

    schedule()
    {:noreply, state}
  end

  defp schedule() do
    Process.send_after(self(), :heartbeat, 5000)
  end
end
