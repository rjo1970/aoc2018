defmodule Day3.Record do
  defstruct id: nil, origin: [0, 0], size: [1, 1], area: []

  def convert(string) do
    [id, ox, oy, sx, sy] =
      Regex.run(~r/#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)/, string)
      |> Stream.drop(1)
      |> Enum.map(fn x -> String.to_integer(x) end)

    area =
      for x <- ox..(ox + sx - 1), y <- oy..(oy + sy - 1) do
        {x, y}
      end
      |> MapSet.new()

    %Day3.Record{
      id: id,
      origin: [ox, oy],
      size: [sx, sy],
      area: area
    }
  end
end
