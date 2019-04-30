defmodule TaocupaoAppNerves.Repo do
  use Ecto.Repo,
    otp_app: :taocupao_app_nerves,
    adapter: Ecto.Adapters.Postgres
end
