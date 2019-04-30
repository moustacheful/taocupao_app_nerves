use Mix.Config

keys =
  File.cwd!()
  |> Path.join("keys/*.pub")
  |> Path.wildcard()
  |> Enum.map(fn p -> File.read!(p) end)

config :nerves_firmware_ssh,
  authorized_keys: keys

config :nerves_network,
  regulatory_domain: "CL"

config :nerves_network, :default,
  eth0: [
    ipv4_address_method: :dhcp
  ]

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcp,
  ssh_console_port: 22

config :taocupao_app_nerves, AnalogReader,
  implementation: AnalogReaderCircuitsUART,
  serial_port: "ttyUSB0"
