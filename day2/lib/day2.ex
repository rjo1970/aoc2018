defmodule Day2 do
  def find_ids() do
    Day1.read_entries("box_ids.txt")
  end

  def letter_frequencies(box_id) do
      box_id
      |> String.split("")
      |> Enum.filter(fn x -> x != "" end)
      |> Enum.group_by(fn x -> x end)
      |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
  end

  def has_pair?(freq) do
    Enum.any?(freq, fn {_x, y} -> y == 2 end)
  end

  def has_triple?(freq) do
    Enum.any?(freq, fn {_x, y} -> y == 3 end)
  end

  def score_box_id(box_id) do
    freq = letter_frequencies(box_id)
    {has_pair?(freq), has_triple?(freq)}
  end

  def score_sum(selected_bools) do
    selected_bools
    |> Enum.filter(fn x -> x end)
    |> Enum.map(fn _x -> 1 end)
    |> Enum.sum()
  end

  def checksum(scores) do
    pairs = scores |> Enum.map(fn {x, _y} -> x end) |> score_sum()
    triples = scores |> Enum.map(fn {_x, y} -> y end) |> score_sum()
    pairs * triples
  end

end
