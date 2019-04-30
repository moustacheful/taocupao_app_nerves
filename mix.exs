defmodule TaocupaoAppNerves.MixProject do
  use Mix.Project

  @all_targets [:rpi3, :rpi]

  def project do
    [
      app: :taocupao_app_nerves,
      version: "0.1.0",
      elixir: "~> 1.6",
      archives: [nerves_bootstrap: "~> 1.0"],
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.target() != :host,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {TaocupaoAppNerves.Application, []},
      extra_applications: [:logger, :runtime_tools, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, "~> 1.3", runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"},
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:joken, "~> 2.0"},
      {:json_web_token, "~> 0.2"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:circuits_uart, "~> 1.2"},

      # All targets but host
      {:nerves_runtime, "~> 0.6", targets: @all_targets},
      {:nerves_init_gadget, "~> 0.6", targets: @all_targets},
      {:nerves_time, "~> 0.2", targets: @all_targets},

      # Target specific
      {:nerves_system_rpi3, "~> 1.7", runtime: false, targets: :rpi3},
      {:nerves_system_rpi_mt7601u,
       git: "https://github.com/moustacheful/nerves_system_rpi_mt7601u",
       tag: "v1.8.0",
       runtime: false,
       targets: :rpi}
    ]
  end
end
