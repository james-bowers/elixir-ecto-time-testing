defmodule Example.Repo.Migrations.Measurement do
  use Ecto.Migration

  def change do
    create table("measurement") do
      add(:time, :utc_datetime, null: false)
    end
  end
end
