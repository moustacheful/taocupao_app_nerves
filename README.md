# TaocupaoAppNerves

**TODO: Add description**

## Installation

#### Install nerves and required dependencies

https://hexdocs.pm/nerves/installation.html

The application requires Elixir v1.8

#### Install dependencies

```bash
mix deps.get
```

### Configuration

Secrets are passed through the `secrets.exs` file within `/config` directory.

Copy and rename `secrets.exs.example` for an example of what to setup.

### Running

After setting up the application, execute

```sh
docker-compose up # Brings any needed services up
mix ecto.migrate # Only needed once to run migrations on the db
```

### Development, host machine

```
iex -S mix
```

### Deploying to targets

Where target = your target, eg: `rpi0`, `rpi`, `rpi2`, `rpi3`

You may need to install dependencies for a particular target as well

```bash
env MIX_TARGET=target mix deps.get
```

#### Building and burning to sd

```bash
env MIX_TARGET=target mix firmware
env MIX_TARGET=target mix firmware.burn
```

### Remote operation and deployment

Where HOSTNAME = the domain defined on each remote device. See the respective target config on `/config`, where each should have a `mdns_domain` corresponding to this HOSTNAME

For this to work you must:

- Put `keys/taocupao.pem` private key and `keys/taocupao.pub` public key (they will all be included automatically -- as long as they have a `.pub` extension).
- Be in the same wifi connection as the devices. If this the first time installing the firmware, refer to the "Building and burning to sd"

#### Remote deployment

```bash
env MIX_TARGET=rpi mix firmware
env MIX_TARGET=rpi ./upload.sh HOSTNAME
```

#### Remote inspection

```bash
ssh -i ./keys/taocupao.pem HOSTNAME
```

This will put you in iex (interactive elixir) remotely.

##### Useful commands

For any command that requires an `input`, this corresponds to the input on the arduino.

`RingLogger.attach`: Start logging for the application to your iex instance.

`Tracker.inspect(input)`: Prints the currrent state for a particular tracker (sensor)

`Tracker.set_threshold(input, value)`: Sets a new threshold for a particular sensor

`Tracker.start_log(input)`: Starts logging the current values being read from arduino

`Tracker.stop_log(input)`: Stops logging the current values being read from arduino

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that # TaocupaoAppNerves

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:

- `export MIX_TARGET=my_target` or prefix every command with
  `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
- Install dependencies with `mix deps.get`
- Create firmware with `mix firmware`
- Burn to an SD card with `mix firmware.burn`

## Learn more

- Official docs: https://hexdocs.pm/nerves/getting-started.html
- Official website: https://nerves-project.org/
- Forum: https://elixirforum.com/c/nerves-forum
- Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
- Source: https://github.com/nerves-project/nerves
