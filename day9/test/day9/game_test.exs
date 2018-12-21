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

  test "insert marble" do
    state = %{
      0 => %Day9.Marble{id: 0, current: false, left: 1, right: 1},
      1 => %Day9.Marble{id: 1, current: true, left: 0, right: 0}
    }

    assert Day9.Game.insert_marble(2, state) == %{
             0 => %Day9.Marble{id: 0, current: false, left: 1, right: 2},
             1 => %Day9.Marble{id: 1, current: false, left: 2, right: 0},
             2 => %Day9.Marble{id: 2, current: true, left: 0, right: 1}
           }
  end

  test "insert first marble" do
    assert Day9.Game.insert_marble(0, %{}) == %{
             0 => %Day9.Marble{id: 0, current: true, left: 0, right: 0}
           }
  end

  test "insert second marble" do
    state = %{
      0 => %Day9.Marble{id: 0, current: true, left: 0, right: 0}
    }

    assert Day9.Game.insert_marble(1, state) == %{
             0 => %Day9.Marble{current: false, id: 0, left: 1, right: 1},
             1 => %Day9.Marble{current: true, id: 1, left: 0, right: 0}
           }
  end
end
