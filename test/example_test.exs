defmodule ExampleTest do
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Example.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Example.Repo, {:shared, self()})
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

  describe "reads dates by hour" do
    setup do
      {:ok, _} = Example.insert(~U[2020-09-10 07:10:00Z])
      {:ok, _} = Example.insert(~U[2020-09-10 07:15:00Z])
      {:ok, _} = Example.insert(~U[2020-09-10 08:07:00Z])
      {:ok, _} = Example.insert(~U[2020-09-10 08:37:00Z])
      {:ok, _} = Example.insert(~U[2020-09-10 08:57:00Z])
      {:ok, _} = Example.insert(~U[2020-09-10 09:10:00Z])
      {:ok, _} = Example.insert(~U[2020-09-10 09:15:00Z])

      :ok
    end

    test "time_utc_datetime postgres field type" do
      assert [
               [~N[2020-09-10 07:00:00.000000], 1],
               [~N[2020-09-10 07:00:00.000000], 1],
               [~N[2020-09-10 08:00:00.000000], 1],
               [~N[2020-09-10 08:00:00.000000], 1],
               [~N[2020-09-10 08:00:00.000000], 1],
               [~N[2020-09-10 09:00:00.000000], 1],
               [~N[2020-09-10 09:00:00.000000], 1]
             ] == Example.read("time_utc_datetime")
    end

    test "time_timestamp postgres field type" do
      assert [
               [~N[2020-09-10 07:00:00.000000], 1],
               [~N[2020-09-10 07:00:00.000000], 1],
               [~N[2020-09-10 08:00:00.000000], 1],
               [~N[2020-09-10 08:00:00.000000], 1],
               [~N[2020-09-10 08:00:00.000000], 1],
               [~N[2020-09-10 09:00:00.000000], 1],
               [~N[2020-09-10 09:00:00.000000], 1]
             ] == Example.read("time_timestamp")
    end

    test "time_timestamptz postgres field type" do
      assert [
               [~U[2020-09-10 07:00:00.000000Z], 1],
               [~U[2020-09-10 07:00:00.000000Z], 1],
               [~U[2020-09-10 08:00:00.000000Z], 1],
               [~U[2020-09-10 08:00:00.000000Z], 1],
               [~U[2020-09-10 08:00:00.000000Z], 1],
               [~U[2020-09-10 09:00:00.000000Z], 1],
               [~U[2020-09-10 09:00:00.000000Z], 1]
             ] == Example.read("time_timestamptz")
    end
  end
end
