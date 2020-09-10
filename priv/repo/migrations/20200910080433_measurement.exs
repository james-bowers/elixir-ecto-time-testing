defmodule Example.Repo.Migrations.Measurement do
  use Ecto.Migration

  def change do

    # ENSURE POSTGRES IS `UTC` IN DB CONFIG

    create table("measurement") do
      add(:time_utc_datetime, :utc_datetime, null: false)
      add(:time_timestamp, :timestamp, null: false)
      add(:time_timestamptz, :timestamptz, null: false)
    end
  end
end
