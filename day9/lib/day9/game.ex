defmodule Day9.Game do
  use GenServer

  def start_link(
        state \\ %{
          0 => %Day9.Marble{id: 0, current: true, left: 0, right: 0}
        }
      ) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  ############ API ##########

  def handle_cast({:insert, n}, state) do
    state = insert_marble(state, n)
    {:noreply, state}
  end

  def handle_call(:pickup, _from, state) do
    {id, state} = pick_up(state)
    {:reply, id, state}
  end

  ########### IMPL ##########

  def find_current(state) do
    [{_k, v}] =
      state
      |> Stream.filter(fn {_k, v} -> v.current end)
      |> Enum.take(1)

    v
  end

  def right_moves(state) do
    current = find_current(state)
    right1 = Map.get(state, current.right)
    right2 = Map.get(state, right1.right)
    {right1, right2}
  end

  def seven_left(state) do
    current = find_current(state)
    left = Map.get(state, current.left)
    left = Map.get(state, left.left)
    left = Map.get(state, left.left)
    left = Map.get(state, left.left)
    left = Map.get(state, left.left)
    left = Map.get(state, left.left)
    Map.get(state, left.left)
  end

  def nothing_current(state) do
    updates =
      state
      |> Stream.filter(fn {_k, v} -> v.current end)
      |> Stream.take(1)
      |> Enum.map(fn {k, v} ->
        {k, Map.put(v, :current, false)}
      end)
      |> Map.new()

    Map.merge(state, updates)
  end

  defp connect_ends(state, a, a) do
    a =
      a
      |> Map.put(:left, a.id)
      |> Map.put(:right, a.id)

    Map.put(state, a.id, a)
  end

  defp connect_ends(state, a, b) do
    a =
      a
      |> Map.put(:right, b.id)

    b =
      b
      |> Map.put(:left, a.id)

    state
    |> Map.put(a.id, a)
    |> Map.put(b.id, b)
  end

  def remove(state, marble) do
    left = Map.get(state, marble.left)
    right = Map.get(state, marble.right)

    connect_ends(state, left, right)
    |> Map.delete(marble.id)
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

  def insert_marble(state, n) when state == %{} do
    %{
      n => %Day9.Marble{
        id: n,
        current: true,
        left: n,
        right: n
      }
    }
  end

  def insert_marble(state, n) do
    {right1, right2} = right_moves(state)
    state = nothing_current(state)
    insert(state, right1, right2, n)
  end

  def pick_up(state) do
    target = seven_left(state)

    new_current_id = target.right

    state =
      remove(state, target)
      |> nothing_current()
      |> Map.update!(new_current_id, fn v ->
        Map.put(v, :current, true)
      end)

    {target.id, state}
  end
end
