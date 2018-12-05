defmodule Day3 do
  def read_claims() do
    Day1.read_entries("cloth_claims.txt")
  end

  def claims() do
    read_claims()
    |> Enum.map(&Day3.Record.convert/1)
  end

  def contended_inches() do
    claims = claims()
    for x <- claims, y <- claims, x != y do
      MapSet.intersection(x.area,y.area)
      |> MapSet.to_list()
    end
    |> List.flatten()
    |> Stream.uniq()
    |> Enum.count()
  end

  def uncontended_claims() do
    empty = MapSet.new()
    claims = claims()

    not_the_ones =
      for x <- claims, y <- claims, x != y do
        {x.id, y.id, MapSet.intersection(x.area,y.area)}
      end
      |> Stream.filter(fn {_x, _y, intersection} ->
         intersection != empty
      end)
      |> Stream.map(fn {x, y, _} -> [x, y] end)
      |> Enum.to_list()
      |> List.flatten()
      |> Enum.uniq()
      |> MapSet.new()

    1..1397
    |> MapSet.new()
    |> MapSet.difference(not_the_ones)
    |> MapSet.to_list()
    |> hd()
  end
end
