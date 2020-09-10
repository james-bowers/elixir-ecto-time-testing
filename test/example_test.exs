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
              time: ~U[2020-09-10 08:07:31Z]
            }} = Example.insert(dt)

    assert [
             %Example.Measurement{
               time: ~U[2020-09-10 08:07:31Z]
             }
           ] = Example.Repo.all(Example.Measurement)
  end

  describe "group dates by hour" do
    setup do
      Example.insert(~U[2020-09-10 07:10:00Z])
      Example.insert(~U[2020-09-10 07:15:00Z])
      Example.insert(~U[2020-09-10 08:07:00Z])
      Example.insert(~U[2020-09-10 08:37:00Z])
      Example.insert(~U[2020-09-10 08:57:00Z])
      Example.insert(~U[2020-09-10 09:10:00Z])
      Example.insert(~U[2020-09-10 09:15:00Z])

      :ok
    end

    test "returns the inserted dates, grouped hourly" do
      # I expected these to have timezone info, so would be UTC, not Naive.
      # Is this OK, and I can convert these to UTC by
      # using `DateTime.from_naive/2`, e.g:
      # DateTime.from_naive(~N[2020-09-10 08:00:00.000000], "Etc/UTC")
      # {:ok, ~U[2020-09-10 08:00:00.000000Z]}

      assert [
               [~N[2020-09-10 08:00:00.000000], 1],
               [~N[2020-09-10 08:00:00.000000], 1],
               [~N[2020-09-10 08:00:00.000000], 1],
               [~N[2020-09-10 07:00:00.000000], 1],
               [~N[2020-09-10 09:00:00.000000], 1],
               [~N[2020-09-10 09:00:00.000000], 1],
               [~N[2020-09-10 07:00:00.000000], 1]
             ] == Example.read()
    end
  end
end
