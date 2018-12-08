defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "manhattan distance" do
    assert Day6.manhattan_distance({0, 2}, {1, 1}) == 2
  end

  @points [{1, 1}, {1, 6}, {8, 3}, {3, 4}, {5, 5}, {8, 9}]
  @plane for x <- 0..10, y <- 0..10, do: {x, y}

  test "returns two closest point distances" do
    distances = Day6.distances(@plane, @points)

    assert Map.get(distances, {1, 1}) |> Enum.count() == 6
  end

  test "can score distances" do
    assert Day6.distances(@plane, @points)
           |> Day6.score_distances() == [
             {{1, 1}, 15},
             {{1, 6}, 17},
             {{3, 4}, 9},
             {{5, 5}, 17},
             {{8, 3}, 27},
             {{8, 9}, 23}
           ]
  end

  test "can compare different planes vs same points" do
    s1 = Day6.distances(@plane, @points) |> Day6.score_distances()
    plane2 = for x <- -1..11, y <- -1..11, do: {x, y}
    s2 = Day6.distances(plane2, @points) |> Day6.score_distances()

    assert Enum.zip(s1, s2)
           |> Enum.filter(fn {{p, s1}, {p, s2}} -> s1 == s2 end) == [
             {{{3, 4}, 9}, {{3, 4}, 9}},
             {{{5, 5}, 17}, {{5, 5}, 17}}
           ]
  end
end
