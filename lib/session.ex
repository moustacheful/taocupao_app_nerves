defmodule Session do
  use Ecto.Schema

  @min_session_time Application.get_env(:taocupao_app_nerves, :min_session_time)

  schema "sessions" do
    field(:start_time, :utc_datetime)
    field(:end_time, :utc_datetime)
    field(:duration, :integer)
    field(:index, :integer)
    field(:name, :string)
  end

  def create(%Session{duration: duration}) when duration < @min_session_time do
    {:err, :min_session_time}
  end

  def create(%Session{} = session) do
    TaocupaoAppNerves.Repo.insert(session)
  end
end
