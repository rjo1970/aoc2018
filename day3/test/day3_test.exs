defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "reads claims" do
    claims = Day3.read_claims()
    assert claims |> Enum.count() == 1397
  end

  test "convert record" do
    record =
      "#1 @ 287,428: 3x3"
      |> Day3.Record.convert()

    assert record.id == 1
    assert record.origin == [287, 428]
    assert record.size == [3, 3]
    assert record.area |> Enum.count() == 9
  end

  test "claims are converted to claim records" do
    claims =
      Day3.read_claims()
      |> Enum.map(&Day3.Record.convert/1)

    %Day3.Record{} =
      claims
      |> Enum.take(1)
      |> hd()
  end

  test "calculates contended inches" do
    assert Day3.contended_inches() == 116140
  end

  test "finds uncontended claim" do
    assert Day3.uncontended_claims() == 574
  end
end
