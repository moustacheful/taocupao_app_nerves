defmodule TaocupaoAppNerves.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add(:start_time, :utc_datetime)
      add(:end_time, :utc_datetime)
      add(:duration, :integer)
      add(:index, :integer)
      add(:name, :string)
    end
  end
end
