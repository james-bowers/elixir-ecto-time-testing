defmodule Example do
  @moduledoc """
  Documentation for Example.
  """

  def insert(datetime) do
    Example.Repo.insert(%Example.Measurement{
      time_utc_datetime: datetime,
      time_timestamp: datetime,
      time_timestamptz: datetime
    })
  end

  def read(field, granularity \\ "hour")

  def read("time_utc_datetime", granularity) do
    import Ecto.Query

    from(
      m in Example.Measurement,
      select: type(fragment("date_trunc(?, ?)", ^granularity, m.time_utc_datetime), :utc_datetime),
      group_by: :time_utc_datetime,
      order_by: :time_utc_datetime
    )
    |> Example.Repo.all()
  end

  def read("time_timestamp", granularity) do
    import Ecto.Query

    from(
      m in Example.Measurement,
      select: type(fragment("date_trunc(?, ?)", ^granularity, m.time_timestamp), :utc_datetime),
      group_by: :time_timestamp,
      order_by: :time_timestamp
    )
    |> Example.Repo.all()
  end

  def read("time_timestamptz", granularity) do
    import Ecto.Query

    from(
      m in Example.Measurement,
      select: type(fragment("date_trunc(?, ?)", ^granularity, m.time_timestamptz), :utc_datetime),
      group_by: :time_timestamptz,
      order_by: :time_timestamptz
    )
    |> Example.Repo.all()
  end
end
