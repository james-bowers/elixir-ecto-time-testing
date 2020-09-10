defmodule Example.Repo.Migrations.Measurement do
  use Ecto.Migration

  def change do
    create table("measurement") do
      add(:time_utc_datetime, :utc_datetime, null: false)
      add(:time_timestamp, :timestamp, null: false)
      add(:time_timestamptz, :timestamptz, null: false)
    end
  end
end
