defmodule Day9.GameTest do
  use ExUnit.Case

  test "find the current from default" do
    assert Day9.Game.find_current(%{0 => %Day9.Marble{id: 0, current: true, left: 0, right: 0}}) ==
             %Day9.Marble{id: 0, current: true, left: 0, right: 0}
  end

  test "can walk one to the right" do
    state = %{
      0 => %Day9.Marble{id: 0, current: false, left: 1, right: 1},
      1 => %Day9.Marble{id: 1, current: true, left: 0, right: 0}
    }

    assert Day9.Game.one_right(state) == %Day9.Marble{id: 0, current: false, left: 1, right: 1}
  end

  test "can walk two to the right" do
    state = %{
      0 => %Day9.Marble{id: 0, current: false, left: 1, right: 1},
      1 => %Day9.Marble{id: 1, current: true, left: 0, right: 0}
    }

    assert Day9.Game.two_right(state) == %Day9.Marble{id: 1, current: true, left: 0, right: 0}
  end

  test "insert third marble" do
    state = %{
      0 => %Day9.Marble{id: 0, current: false, left: 1, right: 1},
      1 => %Day9.Marble{id: 1, current: true, left: 0, right: 0}
    }

    assert Day9.Game.insert_marble(state, 2) == %{
             0 => %Day9.Marble{id: 0, current: false, left: 1, right: 2},
             1 => %Day9.Marble{id: 1, current: false, left: 2, right: 0},
             2 => %Day9.Marble{id: 2, current: true, left: 0, right: 1}
           }
  end

  test "insert first marble" do
    assert Day9.Game.insert_marble(%{}, 0) == %{
             0 => %Day9.Marble{id: 0, current: true, left: 0, right: 0}
           }
  end

  test "insert second marble" do
    state = %{
      0 => %Day9.Marble{id: 0, current: true, left: 0, right: 0}
    }

    assert Day9.Game.insert_marble(state, 1) == %{
             0 => %Day9.Marble{current: false, id: 0, left: 1, right: 1},
             1 => %Day9.Marble{current: true, id: 1, left: 0, right: 0}
           }
  end

  def eight_entries() do
    %{}
    |> Day9.Game.insert_marble(0)
    |> Day9.Game.insert_marble(1)
    |> Day9.Game.insert_marble(2)
    |> Day9.Game.insert_marble(3)
    |> Day9.Game.insert_marble(4)
    |> Day9.Game.insert_marble(5)
    |> Day9.Game.insert_marble(6)
    |> Day9.Game.insert_marble(7)
  end

  test "can find the marble 7 to the left" do
    state = eight_entries()

    result = Day9.Game.seven_left(state)

    assert result == %Day9.Marble{current: false, id: 0, left: 7, right: 4}
  end

  test "can remove marble from ring" do
    state = eight_entries()

    result = Day9.Game.remove(state, 0)

    assert result == %{
             1 => %Day9.Marble{current: false, id: 1, left: 5, right: 6},
             2 => %Day9.Marble{current: false, id: 2, left: 4, right: 5},
             3 => %Day9.Marble{current: false, id: 3, left: 6, right: 7},
             4 => %Day9.Marble{current: false, id: 4, left: 7, right: 2},
             5 => %Day9.Marble{current: false, id: 5, left: 2, right: 1},
             6 => %Day9.Marble{current: false, id: 6, left: 1, right: 3},
             7 => %Day9.Marble{current: true, id: 7, left: 3, right: 4}
           }
  end
end
