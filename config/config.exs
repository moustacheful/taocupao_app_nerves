# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.

config :shoehorn,
  init: [:nerves_runtime, :nerves_init_gadget],
  app: Mix.Project.config()[:app]

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

# Set minimum allowed time for sessions to be created

config :taocupao_app_nerves, min_session_time: 5000

# Base config for our ecto repo, use our docker-compose service
config :taocupao_app_nerves, TaocupaoAppNerves.Repo,
  url: "postgres://taocupao:taocupao@localhost:6432/taocupao",
  pool_size: 1

# Declare our repo for ecto

config :taocupao_app_nerves, ecto_repos: [TaocupaoAppNerves.Repo]

# Possible fix / mitigation for hackney's {:ssl_closed} errors?

config :ssl, protocol_version: :"tlsv1.2"

# Import secrets

import_config "secrets.exs"

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

import_config "#{Mix.target()}.exs"
