defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "finds box ids" do
    assert Day2.find_ids() |> Enum.count() == 250
  end

  test "scores a box id" do
    assert "ohwmwtcxjqnzhgkdylftpviusr"
    |> Day2.score_box_id() == {true, false}
  end

  test "calculates a checksum" do
    assert Day2.find_ids()
    |> Enum.map(&Day2.score_box_id/1)
    |> Day2.checksum() == 6916
  end
end
