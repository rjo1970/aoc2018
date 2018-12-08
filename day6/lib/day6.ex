defmodule Day6 do
  def read_points() do
    Day1.read_entries("points.txt")
    |> Enum.map(fn x ->
      String.split(x, ", ")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn [a, b] -> {a, b} end)
  end

  def range(points) do
    xs = Enum.map(points, fn {x, _y} -> x end)
    ys = Enum.map(points, fn {_x, y} -> y end)
    min_x = Enum.min(xs)
    max_x = Enum.max(xs)
    min_y = Enum.min(ys)
    max_y = Enum.max(ys)

    {min_x, min_y, max_x, max_y}
  end

  def tight_comprehension({min_x, min_y, max_x, max_y}) do
    for x <- min_x..max_x, y <- min_y..max_y, do: {x, y}
  end

  def loose_comprehension({min_x, min_y, max_x, max_y}) do
    for x <- (min_x - 5)..(max_x + 5), y <- (min_y - 5)..(max_y + 5), do: {x, y}
  end

  def manhattan_distance({px, py}, {qx, qy}) do
    x_delta = abs(px - qx)
    y_delta = abs(py - qy)
    x_delta + y_delta
  end

  def plane_distances_from_point(plane, point) do
    plane
    |> Enum.map(fn p -> {p, {point, manhattan_distance(p, point)}} end)
  end

  def distances(plane, points) do
    points
    |> Enum.map(fn point ->
      plane_distances_from_point(plane, point)
    end)
    |> List.flatten()
    |> Enum.group_by(fn {a, _b} -> a end, fn {_a, b} -> b end)
    |> Enum.map(fn {k, v} ->
      {k,
       v
       |> Enum.sort(fn {_, b1}, {_, b2} ->
         b1 < b2
       end)}
    end)
    |> Map.new()
  end

  def sum_distances(distances) do
    distances
    |> Enum.map(fn {k, v} ->
      sum =
        v
        |> Enum.map(fn {_point, s} -> s end)
        |> Enum.sum()

      {k, sum}
    end)
    |> Enum.filter(fn {_k, sum} -> sum < 10000 end)
  end

  def score_distances(distances) do
    distances
    |> Enum.map(fn {k, v} ->
      {k, Enum.take(v, 2)}
    end)
    |> Enum.map(fn {k, v} ->
      [{p1, s1}, {p2, s2}] = v

      s =
        cond do
          s1 == s2 -> :none
          s1 < s2 -> p1
          s1 > s2 -> p2
        end

      {k, s}
    end)
    |> Enum.group_by(fn {_point, score} -> score end, fn {point, _score} -> point end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.filter(fn {k, _v} -> k != :none end)
  end

  def problem1() do
    points = read_points()
    range = range(points)

    s1 =
      distances(tight_comprehension(range), points)
      |> score_distances()

    s2 =
      distances(loose_comprehension(range), points)
      |> score_distances()

    Enum.zip(s1, s2)
    |> Enum.filter(fn {{p, s1}, {p, s2}} -> s1 == s2 end)
    |> Enum.sort(fn {_, {_, s1}}, {_, {_, s2}} -> s1 > s2 end)
    |> Enum.take(1)
    |> Enum.map(fn {_, {_, s1}} -> s1 end)
  end

  def problem2() do
    points = read_points()
    range = range(points)

    distances(tight_comprehension(range), points)
    |> sum_distances()
    |> Enum.count()
  end
end
