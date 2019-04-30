defmodule Tracker do
  use GenServer
  require Logger

  def child_spec(args) do
    %{
      id: get_key(args.input),
      start: {Tracker, :new, [args]}
    }
  end

  def init(args) do
    %{
      # TODO?
      _listeners: [],
      _threshold: args.threshold,
      _log: false,
      since: System.system_time(:millisecond),
      input: args.input,
      index: args.index,
      label: args.label,
      active: false,
      lastDuration: 0
    }
    |> Pipe.tap_async(fn state ->
      TrackerHooks.on({:propagate, state})
    end)
    |> Pipe.tuple({:ok})
  end

  def handle_cast({:set_state, new_state}, state) do
    {:noreply, Map.merge(state, new_state)}
  end

  def handle_cast({:set_value, val}, state) do
    if state._log do
      Logger.info("Tracker #{state.index} - received: #{val}")
    end

    active = val > state._threshold
    prev_active = state.active

    if prev_active != active do
      GenServer.cast(self(), :on_change)
    end

    {:noreply, Map.put(state, :active, active)}
  end

  def handle_cast(:on_change, state) do
    now = System.system_time(:millisecond)

    partial_state =
      case state.active do
        true -> %{since: now}
        _ -> %{lastDuration: now - state.since}
      end

    Map.merge(state, partial_state)
    |> Pipe.tap_async(fn data ->
      TrackerHooks.on({:propagate, data})
    end)
    |> Pipe.tap_async(fn data ->
      if !data.active do
        TrackerHooks.on({:session, data})
      end
    end)
    |> Pipe.tuple({:noreply})
  end

  def new(options) do
    GenServer.start_link(__MODULE__, options, name: get_key(options.input))
  end

  def set_value(input, value) do
    GenServer.cast(get_key(input), {:set_value, value})
  end

  def set_threshold(input, value) do
    GenServer.cast(get_key(input), {:set_state, %{_threshold: value}})
  end

  def start_log(input) do
    GenServer.cast(get_key(input), {:set_state, %{_log: true}})
  end

  def stop_log(input) do
    GenServer.cast(get_key(input), {:set_state, %{_log: false}})
  end

  def inspect(input) do
    get_key(input)
    |> :sys.get_state()
  end

  defp get_key(input) do
    String.to_atom("tracker_#{input}")
  end
end
