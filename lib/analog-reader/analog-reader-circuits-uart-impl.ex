defmodule AnalogReaderCircuitsUART do
  @behaviour AnalogReader

  @impl AnalogReader
  def init(args) do
    serial_port = Keyword.fetch!(args, :serial_port)
    {:ok, uart} = Circuits.UART.start_link()

    :ok =
      Circuits.UART.open(uart, "ttyUSB0",
        speed: 115_200,
        framing: {Circuits.UART.Framing.Line, separator: "\r\n"},
        active: true
      )

    {:ok, uart}
  end
end
