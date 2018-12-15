defmodule Day8 do
  def puzzle_data() do
    File.stream!("puzzle.txt")
    |> Enum.map(fn x -> String.split(x, " ") end)
    |> List.flatten()
    |> Enum.map(fn x -> String.to_integer(x) end)

    # [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]
  end

  def parse(data) when is_list(data) do
    IO.inspect(data)

    [count, metacount] =
      data
      |> Enum.take(2)

    next =
      data
      |> Enum.drop(2)

    IO.inspect({[count], [metacount], [], next})
    parse({[count], [metacount], [], next})
  end

  def parse({[], [], metadata, []}) do
    IO.inspect({:donedone})
    metadata
  end

  def parse({[], [n | metacounts], metadata, data}) do
    more_meta =
      data
      |> Enum.take(n)

    rest =
      data
      |> Enum.drop(n)

    IO.inspect({[], metacounts, metadata ++ more_meta, rest})
    parse({[], metacounts, metadata ++ more_meta, rest})
  end

  def parse({[0 | counts], [n | metacounts], metadata, data}) do
    more_meta =
      data
      |> Enum.take(n)

    rest =
      data
      |> Enum.drop(n)

    IO.inspect({counts, metacounts, metadata ++ more_meta, rest})
    parse({counts, metacounts, metadata ++ more_meta, rest})
  end

  def parse({[c | counts], metacounts, metadata, [0, n | rest]}) do
    more_meta =
      rest
      |> Enum.take(n)

    data =
      rest
      |> Enum.drop(n)

    next_counts = [c - 1 | counts]

    IO.inspect({next_counts, metacounts, metadata ++ more_meta, data})
    parse({next_counts, metacounts, metadata ++ more_meta, data})
  end

  def parse({[c | counts], metacounts, metadata, data}) do
    [count, metacount] =
      data
      |> Enum.take(2)

    next =
      data
      |> Enum.drop(2)

    IO.inspect({[count, c - 1 | counts], [metacount | metacounts], metadata, next})

    parse({[count, c - 1 | counts], [metacount | metacounts], metadata, next})
  end
end
