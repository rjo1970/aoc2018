defmodule Day4 do
  def read_schedule do
    Day1.read_entries("sleep_schedule.txt")
    |> Enum.sort()
    |> Enum.map(&Day4.parse_entry/1)
  end

  def parse_entry(entry) do
    [_, day, hour, min] = Regex.run(~r/\[\d{4}-\d{2}-(\d{2}) (\d{2}):(\d{2})\]/, entry)

    [_, guard] =
      case Regex.run(~r/Guard #(\d+) begins shift/, entry) do
        nil -> [nil, nil]
        x -> x
      end

    asleep = Regex.match?(~r/falls asleep/, entry)
    awake = Regex.match?(~r/wakes up/, entry)

    %{
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
        true -> [[head.hour, head.min], false]
        false -> [step.last_asleep, step.last_awake]
      end

    last_awake =
      case head.awake do
        true -> [head.hour, head.min - 1]
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

  def minute_blocks({guard, [sh, sm], [fh, fm]}) do
    minutes = for h <- sh..fh, m <- sm..fm, do: {h, m}
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

  def sofar() do
    Day4.read_schedule()
    |> Day4.guard_duty()
    |> Enum.map(&Day4.minute_blocks/1)
    |> Day4.combine_by_guard()
  end

  def golden_hours(guard_map) do
    guard_map
    |> Enum.map(fn {k, v} ->
      {k,
       v
       |> List.flatten()
       |> Enum.group_by(fn x -> x end)
       |> Enum.map(fn {k1, v1} -> {k1, Enum.count(v1)} end)
       |> Enum.sort(fn {_ka, va}, {_kb, vb} -> va > vb end)
       |> Enum.take(1)
       |> hd()}
    end)
  end
end
