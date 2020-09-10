defmodule Example do
  @moduledoc """
  Documentation for Example.
  """

  def insert(datetime) do
    Example.Repo.insert(%Example.Measurement{
      time: datetime
    })
  end

  def read do
    import Ecto.Query

    granularity = "hour"

    from(
      m in Example.Measurement,
      select: [fragment("date_trunc(?, time)", ^granularity), count(m.id)],
      group_by: m.time
    )
    |> Example.Repo.all()
  end
end
