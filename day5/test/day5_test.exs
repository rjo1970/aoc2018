defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "adjacent, opposite" do
    assert Day5.react("aA") == ""
  end

  test "abBA" do
    assert Day5.react("abBA") == ""
  end

  test "abAB" do
    assert Day5.react("abAB") == "abAB"
  end

  test "aabAAB" do
    assert Day5.react("aabAAB") == "aabAAB"
  end

  test "dabAcCaCBAcCcaDA" do
    assert Day5.react("dabAcCaCBAcCcaDA") == "dabCBAcaDA"
  end

  @tag timeout: 300_000
  test "first problem" do
    data = Day5.read_data()

    assert data
           |> Day5.react()
           |> String.length() == 10598
  end

  test "best removal test" do
  end
end
