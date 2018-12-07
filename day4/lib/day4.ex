defmodule Day4 do
  def read_schedule do
    Day1.read_entries("sleep_schedule.txt")
    |> Enum.sort()
    |> Enum.map(&Day4.parse_entry/1)
  end

  def parse_entry(entry) do
    [_, month, day, hour, min] = Regex.run(~r/\[\d{4}-(\d{2})-(\d{2}) (\d{2}):(\d{2})\]/, entry)

    [_, guard] =
      case Regex.run(~r/Guard #(\d+) begins shift/, entry) do
        nil -> [nil, nil]
        x -> x
      end

    asleep = Regex.match?(~r/falls asleep/, entry)
    awake = Regex.match?(~r/wakes up/, entry)

    %{
      month: String.to_integer(month),
      day: String.to_integer(day),
      hour: String.to_integer(hour),
      min: String.to_integer(min),
      asleep: asleep,
      awake: awake,
      guard: guard
    }
  end

  def guard_duty(list) when is_list(list) do
    guard_duty(%{guard: nil, last_asleep: false, last_awake: false, zzz: [], list: list})
  end

  def guard_duty(%{list: []} = step) do
    step.zzz
  end

  def guard_duty(step) do
    [head | tail] = step.list
    guard = head.guard || step.guard

    [last_asleep, _last_awake] =
      case head.asleep do
        true -> [[head.day * head.month * head.month, head.min], false]
        false -> [step.last_asleep, step.last_awake]
      end

    last_awake =
      case head.awake do
        true -> [head.day * head.month * head.month, head.min - 1]
        false -> false
      end

    zzz =
      if guard && last_awake && last_asleep do
        [{guard, last_asleep, last_awake} | step.zzz]
      else
        step.zzz
      end

    guard_duty(%{
      guard: guard,
      last_asleep: last_asleep,
      last_awake: last_awake,
      zzz: zzz,
      list: tail
    })
  end

  def minute_blocks({guard, [sd, sm], [fd, fm]}) do
    minutes = for d <- sd..fd, m <- sm..fm, do: {d, m}
    {guard, minutes}
  end

  def combine_by_guard(blocks) when is_list(blocks) do
    combine_by_guard({%{}, blocks})
  end

  def combine_by_guard({guards, []}) do
    guards
  end

  def combine_by_guard({guards, [{guard, time} | tail]}) do
    a_guard =
      guards
      |> Map.get(guard, [])

    guard_value = [time | a_guard]

    new_guards = Map.put(guards, guard, guard_value)

    combine_by_guard({new_guards, tail})
  end

  def solutions() do
    map =
      Day4.read_schedule()
      |> Day4.guard_duty()
      |> Enum.map(&Day4.minute_blocks/1)
      |> Day4.combine_by_guard()

    Map.keys(map)
    |> Enum.map(fn k ->
      {k, as_minutes(map, k), most_for_minute(map, k), golden_hours(map, k)}
    end)
  end

  def as_minutes(map, key) do
    map
    |> Map.get(key)
    |> List.flatten()
    |> Enum.group_by(fn {day, _} -> day end)
    |> Enum.map(fn {_k, v} -> v |> Enum.map(fn {_day, minute} -> minute end) end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn s, a ->
      Map.update(a, s, 1, fn x -> x + 1 end)
    end)
    |> Enum.sort(fn {ak, av}, {bk, bv} -> av > bv end)
    |> IO.inspect()
  end

  def most_for_minute(map, key) do
    map
    |> Map.get(key)
    |> List.flatten()
    |> Enum.group_by(fn {day, _} -> day end)
    |> Enum.map(fn {k, v} ->
      minutes =
        v
        |> Enum.map(fn {_day, minute} -> minute end)

      minutes
    end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn s, a ->
      Map.update(a, s, 1, fn x -> x + 1 end)
    end)
    |> Enum.sort(fn {ak, av}, {bk, bv} -> av > bv end)
    |> Enum.take(1)
    |> IO.inspect()
  end

  def golden_hours(guard_map, key) do
    size =
      guard_map
      |> Map.get(key)
      |> List.flatten()
      |> Enum.count()

    {key, size}
  end
end
