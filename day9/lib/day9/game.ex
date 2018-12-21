defmodule Day9.Game do
  use GenServer

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  ############ API ##########

  def handle_call({:insert, n}, _from, state) do
    state = insert_marble(n, state)
    {:reply, :l8r, state}
  end

  ########### IMPL ##########

  def find_current(state) do
    {_k, v} =
      state
      |> Enum.filter(fn {_k, v} -> v.current end)
      |> List.first()

    v
  end

  def one_right(state) do
    current = find_current(state)
    Map.get(state, current.right)
  end

  def two_right(state) do
    right1 = one_right(state)
    Map.get(state, right1.right)
  end

  def nothing_current(state) do
    state
    |> Enum.map(fn {k, v} ->
      {k, Map.put(v, :current, false)}
    end)
    |> Map.new()
  end

  def insert(state, a, a, n) do
    entry = Day9.Marble.entry(a, a, n)

    a =
      Map.put(a, :right, n)
      |> Map.put(:left, n)
      |> Map.put(:current, false)

    state
    |> Map.put(n, entry)
    |> Map.put(a.id, a)
  end

  def insert(state, right1, right2, n) do
    entry = Day9.Marble.entry(right1, right2, n)

    right1 =
      Map.put(right1, :right, n)
      |> Map.put(:current, false)

    right2 =
      Map.put(right2, :left, n)
      |> Map.put(:current, false)

    state
    |> Map.put(n, entry)
    |> Map.put(right1.id, right1)
    |> Map.put(right2.id, right2)
  end

  def insert_marble(0, %{}) do
    %{
      0 => %Day9.Marble{id: 0, current: true, left: 0, right: 0}
    }
  end

  def insert_marble(n, state) do
    right1 = one_right(state)
    right2 = two_right(state)
    state = nothing_current(state)
    insert(state, right1, right2, n)
  end
end
