defmodule Day9 do
  alias Day9.Game

  def start_game() do
    Game.start_link()
  end

  def stop_game() do
    GenServer.stop(Day9.Game)
  end

  def elf_marble_pairs(elves, marbles) do
    Stream.cycle(1..elves)
    |> Enum.take(marbles)
    |> Enum.zip(1..marbles)
  end

  def game_turn({elf, marble}, acc) when rem(marble, 23) == 0 do
    id = GenServer.call(Day9.Game, :pickup)
    [{elf, id + marble} | acc]
  end

  def game_turn({_elf, marble}, acc) do
    GenServer.cast(Day9.Game, {:insert, marble})
    acc
  end

  def play(elves, marbles) do
    start_game()

    result =
      elf_marble_pairs(elves, marbles)
      |> Enum.reduce([], &game_turn/2)
      |> Enum.reduce(%{}, fn {elf, s}, acc ->
        Map.update(acc, elf, s, &(&1 + s))
      end)
      |> Map.values()
      |> Enum.max()

    stop_game()

    result
  end

  def benchmark() do
    :timer.tc(fn -> Day9.play(13, 7999) end)
  end

  def problem1() do
    play(428, 70825)
  end

  def problem2() do
    play(428, 70825 * 100)
  end
end
