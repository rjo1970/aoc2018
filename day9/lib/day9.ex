defmodule Day9 do
  def start_game() do
    Day9.Game.start_link(%{0 => %Day9.Marble{current: true, left: 0, right: 0}})
  end
end
