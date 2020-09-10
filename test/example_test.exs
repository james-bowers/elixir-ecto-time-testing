defmodule ExampleTest do
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Example.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Example.Repo, {:shared, self()})
  end

  def seed do
    {:ok, _} = Example.insert(~U[2020-09-10 07:10:00Z])
    {:ok, _} = Example.insert(~U[2020-09-10 07:15:00Z])
    {:ok, _} = Example.insert(~U[2020-09-10 08:07:00Z])
    {:ok, _} = Example.insert(~U[2020-09-10 08:37:00Z])
    {:ok, _} = Example.insert(~U[2020-09-10 08:57:00Z])
    {:ok, _} = Example.insert(~U[2020-09-10 09:10:00Z])
    {:ok, _} = Example.insert(~U[2020-09-10 09:15:00Z])
  end

  test "inserts utc date time" do
    dt = ~U[2020-09-10 08:07:31Z]

    assert {:ok,
            %Example.Measurement{
              time_utc_datetime: ~U[2020-09-10 08:07:31Z],
              time_timestamp: ~U[2020-09-10 08:07:31Z],
              time_timestamptz: ~U[2020-09-10 08:07:31Z]
            }} = Example.insert(dt)

    assert [
             %Example.Measurement{
               time_utc_datetime: ~U[2020-09-10 08:07:31Z],
               time_timestamp: ~U[2020-09-10 08:07:31Z],
               time_timestamptz: ~U[2020-09-10 08:07:31Z]
             }
           ] = Example.Repo.all(Example.Measurement)
  end

  describe "reads dates - granularity by hour" do
    setup do
      seed()
      :ok
    end

    test "time_utc_datetime postgres field" do
      assert [
               ~N[2020-09-10 07:00:00.000000],
               ~N[2020-09-10 07:00:00.000000],
               ~N[2020-09-10 08:00:00.000000],
               ~N[2020-09-10 08:00:00.000000],
               ~N[2020-09-10 08:00:00.000000],
               ~N[2020-09-10 09:00:00.000000],
               ~N[2020-09-10 09:00:00.000000]
             ] == Example.read("time_utc_datetime")
    end

    test "time_timestamp postgres field" do
      assert [
               ~N[2020-09-10 07:00:00.000000],
               ~N[2020-09-10 07:00:00.000000],
               ~N[2020-09-10 08:00:00.000000],
               ~N[2020-09-10 08:00:00.000000],
               ~N[2020-09-10 08:00:00.000000],
               ~N[2020-09-10 09:00:00.000000],
               ~N[2020-09-10 09:00:00.000000]
             ] == Example.read("time_timestamp")
    end

    test "time_timestamptz postgres field" do
      assert [
               ~U[2020-09-10 07:00:00.000000Z],
               ~U[2020-09-10 07:00:00.000000Z],
               ~U[2020-09-10 08:00:00.000000Z],
               ~U[2020-09-10 08:00:00.000000Z],
               ~U[2020-09-10 08:00:00.000000Z],
               ~U[2020-09-10 09:00:00.000000Z],
               ~U[2020-09-10 09:00:00.000000Z]
             ] == Example.read("time_timestamptz")
    end
  end

  describe "reads dates - granularity by week" do
    setup do
      seed()
      :ok
    end

    test "time_utc_datetime postgres field" do
      assert [
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000]
             ] == Example.read("time_utc_datetime", "week")
    end

    test "time_timestamp postgres field" do
      assert [
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000],
               ~N[2020-09-07 00:00:00.000000]
             ] == Example.read("time_timestamp", "week")
    end

    test "time_timestamptz postgres field" do
      # why is this not ~U[2020-09-01 00:00:00.000000Z] ?

      assert [
               ~U[2020-09-06 23:00:00.000000Z],
               ~U[2020-09-06 23:00:00.000000Z],
               ~U[2020-09-06 23:00:00.000000Z],
               ~U[2020-09-06 23:00:00.000000Z],
               ~U[2020-09-06 23:00:00.000000Z],
               ~U[2020-09-06 23:00:00.000000Z],
               ~U[2020-09-06 23:00:00.000000Z]
             ] == Example.read("time_timestamptz", "week")
    end
  end

  describe "reads dates - granularity by month" do
    setup do
      seed()
      :ok
    end

    test "time_utc_datetime postgres field" do
      assert [
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000]
             ] == Example.read("time_utc_datetime", "month")
    end

    test "time_timestamp postgres field" do
      assert [
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000],
               ~N[2020-09-01 00:00:00.000000]
             ] == Example.read("time_timestamp", "month")
    end

    test "time_timestamptz postgres field" do
      # why is this not ~U[2020-09-01 00:00:00.000000Z] ?

      assert [
               ~U[2020-08-31 23:00:00.000000Z],
               ~U[2020-08-31 23:00:00.000000Z],
               ~U[2020-08-31 23:00:00.000000Z],
               ~U[2020-08-31 23:00:00.000000Z],
               ~U[2020-08-31 23:00:00.000000Z],
               ~U[2020-08-31 23:00:00.000000Z],
               ~U[2020-08-31 23:00:00.000000Z]
             ] == Example.read("time_timestamptz", "month")
    end
  end

  describe "reads dates - granularity by year" do
    setup do
      seed()
      :ok
    end

    test "time_utc_datetime postgres field" do
      assert [
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000]
             ] == Example.read("time_utc_datetime", "year")
    end

    test "time_timestamp postgres field" do
      assert [
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000],
               ~N[2020-01-01 00:00:00.000000]
             ] == Example.read("time_timestamp", "year")
    end

    test "time_timestamptz postgres field" do
      assert [
               ~U[2020-01-01 00:00:00.000000Z],
               ~U[2020-01-01 00:00:00.000000Z],
               ~U[2020-01-01 00:00:00.000000Z],
               ~U[2020-01-01 00:00:00.000000Z],
               ~U[2020-01-01 00:00:00.000000Z],
               ~U[2020-01-01 00:00:00.000000Z],
               ~U[2020-01-01 00:00:00.000000Z]
             ] == Example.read("time_timestamptz", "year")
    end
  end
end
