defmodule TaocupaoAppNerves.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaocupaoAppNerves.Supervisor]

    Sync.wait_sync()

    Supervisor.start_link(
      [
        Health,
        AnalogReader,
        TaocupaoAppNerves.Repo
      ] ++ children(@target),
      opts
    )
  end

  # List all child processes to be supervised
  def children(:rpi3) do
    [
      {Tracker, %{input: 0, label: "Baño 1", threshold: 100, index: 0}},
      {Tracker, %{input: 1, label: "Baño 2", threshold: 100, index: 1}}
    ]
  end

  def children(:rpi) do
    [
      {Tracker, %{input: 1, label: "Baño 3", threshold: 60, index: 2}},
      {Tracker, %{input: 0, label: "Baño 4", threshold: 100, index: 3}}
    ]
  end

  def children(:host) do
    [
      {Tracker, %{input: 0, label: "Baño 1", threshold: 100, index: 0}},
      {Tracker, %{input: 1, label: "Baño 2", threshold: 100, index: 1}},
      {Tracker, %{input: 2, label: "Baño 3", threshold: 100, index: 2}},
      {Tracker, %{input: 3, label: "Baño 4", threshold: 100, index: 3}}
    ]
  end

  def children(_target) do
    []
  end
end
