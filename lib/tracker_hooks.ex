defmodule TrackerHooks do
  require Logger

  def on({:propagate, tracker}) do
    allowed_keys =
      Map.keys(tracker)
      |> Enum.reject(fn a ->
        Atom.to_string(a)
        |> String.starts_with?("_")
      end)

    tracker
    |> Map.take(allowed_keys)
    |> Jason.encode()
    |> Pipe.ok!()
    |> Pipe.tap(fn json ->
      IO.puts("tracker #{tracker.index} has changed to #{tracker.active}")

      case Firebase.put("/status/tracker_#{tracker.index}.json", json) do
        {:ok, _} ->
          nil

        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.error(Atom.to_string(reason))
      end
    end)
  end

  def on({:session, data}) do
    [start_time, end_time] =
      [
        data.since / 1000,
        (data.since + data.lastDuration) / 1000
      ]
      |> Enum.map(&Kernel.trunc(&1))
      |> Enum.map(&DateTime.from_unix!(&1))

    Session.create(%Session{
      start_time: start_time,
      end_time: end_time,
      duration: data.lastDuration,
      index: data.index,
      name: data.label
    })
  end
end
