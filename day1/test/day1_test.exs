defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "solution 1" do
    assert Day1.solution1() == 479
  end

  test "solution 2" do
    assert Day1.solution2() == 66105
  end
end
