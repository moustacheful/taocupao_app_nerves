use Mix.Config

import_config "rpi_base.exs"

config :nerves_init_gadget,
  mdns_domain: "nerves-pi3.local"
  node_name: "nerves-pi3"
