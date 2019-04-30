defmodule Sync do
  require Logger

  @target Mix.target()

  @doc """
  Checks if we are on the :host environment, if it's not, we wait for
  synchronization from the Nerves.Time.Ntpd process.
  """
  def wait_sync do
    case @target == :host do
      true -> :ok
      false -> wait_sync(nil)
    end
  end

  @doc """
  Checks every 5 seconds if time has been synchronized using Nerves.Time.Ntpd
  It will do this indefinitely, and has no abort mechanism.

  """
  def wait_sync(_, tries \\ 0) do
    Logger.info("Checking for time sync - try: n°#{tries}")

    case Process.whereis(Nerves.Time.Ntpd) != nil && Nerves.Time.synchronized?() do
      true ->
        :ok

      false ->
        receive do
        after
          5000 -> wait_sync(nil, tries + 1)
        end
    end
  end
end
