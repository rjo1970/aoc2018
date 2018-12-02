defmodule Day1 do
  @doc """
    iex> Day1.calibrate_frequency([1,1,1])
    3
  """
  def calibrate_frequency(deltas) do
    deltas
    |> Enum.sum()
  end

  def cycle(deltas) do
    Stream.cycle(deltas)
    |> Enum.take(Enum.count(deltas)*145)
  end

  def next_value(f, cycle) do
      cycle
      |> Enum.take(1)
      |> Enum.map(fn delta -> f + delta end)
      |> hd()
  end

  def sequence(deltas) when is_list(deltas) do
    f = 0
    cycle = cycle(deltas)
    freq =  Map.put(%{}, f, 1)
    sequence({freq, f, cycle})
  end

  def sequence({freq, f, cycle}) do
    new_f = next_value(f, cycle)
    freq_value = Map.get(freq, new_f, 0) + 1
    new_freq = Map.put(freq, new_f, freq_value)

      case (freq_value == 2) do
        true -> new_f
        false -> sequence({new_freq, new_f, Enum.drop(cycle, 1)})
      end
  end

  def read_entries(name \\ "frequencies.txt") do
    File.stream!(name)
    |> Stream.map(fn x ->
      String.trim(x, "\n")
    end)
    |> Enum.to_list()
  end

  def read_deltas() do
    read_entries()
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end

  def solution1() do
    read_deltas()
    |> calibrate_frequency()
  end

  def solution2() do
    read_deltas() |> sequence()
  end
end
