defmodule Example.Measurement do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime]

  schema "measurement" do
    field(:time_utc_datetime, :utc_datetime)
    field(:time_timestamp, :utc_datetime)
    field(:time_timestamptz, :utc_datetime)
  end
end
