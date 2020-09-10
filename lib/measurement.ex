defmodule Example.Measurement do
  use Ecto.Schema
  @timestamps_opts [type: :utc_datetime]

  schema "measurement" do
    field(:time, :utc_datetime)
  end
end
