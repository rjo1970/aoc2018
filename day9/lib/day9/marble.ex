defmodule Day9.Marble do
  defstruct id: nil, current: false, left: 0, right: 0

  def entry(a, b, n) do
    %Day9.Marble{
      id: n,
      current: true,
      left: a.id,
      right: b.id
    }
  end
end
