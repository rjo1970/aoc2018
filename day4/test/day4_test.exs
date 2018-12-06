defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "reads the schedule" do
    result =
      Day4.read_schedule()
      |> Enum.take(3)

    assert result
  end

  test "parse guard start entry" do
    result =
      "[1518-04-09 23:52] Guard #643 begins shift"
      |> Day4.parse_entry()

    assert result == %{asleep: false, awake: false, guard: "643", hour: 23, min: 52, day: 9}
  end

  test "parse guard sleep entry" do
    result =
      "[1518-03-31 00:17] falls asleep"
      |> Day4.parse_entry()

    assert result == %{asleep: true, awake: false, guard: nil, hour: 0, min: 17, day: 31}
  end

  test "parse guard wake entry" do
    result =
      "[1518-03-31 00:42] wakes up"
      |> Day4.parse_entry()

    assert result == %{asleep: false, awake: true, guard: nil, hour: 0, min: 42, day: 31}
  end

  test "minute blocks" do
    result =
      {"3023", [0, 5], [0, 21]}
      |> Day4.minute_blocks()

    assert result ==
             {"3023",
              [
                {0, 5},
                {0, 6},
                {0, 7},
                {0, 8},
                {0, 9},
                {0, 10},
                {0, 11},
                {0, 12},
                {0, 13},
                {0, 14},
                {0, 15},
                {0, 16},
                {0, 17},
                {0, 18},
                {0, 19},
                {0, 20},
                {0, 21}
              ]}
  end

  test "combines all time blocks into a map by guard id" do
    Day4.read_schedule()
    |> Day4.guard_duty()
    |> Enum.map(&Day4.minute_blocks/1)
    |> Day4.combine_by_guard()
  end
end
