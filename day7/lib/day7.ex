defmodule Day7 do
  @parser ~r/Step (\w) must be finished before step (\w) can begin./

  @empty MapSet.new()

  @letter_steps %{
    "A" => 1,
    "B" => 2,
    "C" => 3,
    "D" => 4,
    "E" => 5,
    "F" => 6,
    "G" => 7,
    "H" => 8,
    "I" => 9,
    "J" => 10,
    "K" => 11,
    "L" => 12,
    "M" => 13,
    "N" => 14,
    "O" => 15,
    "P" => 16,
    "Q" => 17,
    "R" => 18,
    "S" => 19,
    "T" => 20,
    "U" => 21,
    "V" => 22,
    "W" => 23,
    "X" => 24,
    "Y" => 25,
    "Z" => 26
  }

  def letter_step_time(letter) do
    Map.get(@letter_steps, letter)
  end

  def all_data() do
    Day1.read_entries("instructions.txt")
  end

  def parse(s, deps) do
    [[_, pred, dep]] = Regex.scan(@parser, s)

    {_, result} =
      Map.get_and_update(deps, dep, fn current ->
        val = current || @empty
        {current, MapSet.put(val, pred)}
      end)

    result
  end

  def parse_all({result, []}) do
    result
  end

  def parse_all({graph, [head | tail]}) do
    new_graph = parse(head, graph)

    parse_all({new_graph, tail})
  end

  def parse_all(list) do
    parse_all({%{}, list})
  end

  def dependencies(deps) do
    with_dependencies =
      deps
      |> Map.keys()
      |> Enum.filter(fn k -> Map.get(deps, k) != MapSet.new() end)
      |> MapSet.new()

    no_dependencies =
      deps
      |> Map.keys()
      |> Enum.filter(fn k -> Map.get(deps, k) == MapSet.new() end)
      |> MapSet.new()

    value_dependencies =
      Map.values(deps)
      |> Enum.map(fn x -> MapSet.to_list(x) end)
      |> List.flatten()

    all_dependencies =
      with_dependencies
      |> MapSet.union(MapSet.new(value_dependencies))
      |> MapSet.union(no_dependencies)

    intersection = MapSet.intersection(all_dependencies, with_dependencies)

    available_tasks =
      MapSet.difference(all_dependencies, intersection)
      |> MapSet.to_list()
      |> Enum.sort()

    {available_tasks |> List.first(), available_tasks |> Enum.count()}
  end

  def next_dependency(deps) do
    {next, _} = dependencies(deps)
    next
  end

  def available_dependencies(deps) do
    {_, count} = dependencies(deps)
    count
  end

  def resolve(deps, last_completed) do
    comp = MapSet.new([last_completed])

    deps
    |> Enum.filter(fn {k, _} -> k != last_completed end)
    |> Enum.map(fn {k, v} ->
      {k, MapSet.difference(v, comp)}
    end)
    |> Map.new()
  end

  def all_dependencies(list) when is_list(list) do
    map = parse_all(list)
    all_dependencies({[], [], map})
  end

  def all_dependencies({dependencies, nil, _map}) do
    dependencies
    |> Enum.filter(fn x -> x != nil end)
  end

  def all_dependencies({dependencies, _last_dependency, map}) do
    last_dependency = next_dependency(map)
    next_map = resolve(map, last_dependency)
    all_dependencies({dependencies ++ [last_dependency], last_dependency, next_map})
  end

  def update_progress(progress) do
    progress
    |> Enum.map(fn {worker, {task, time}} ->
      {worker, {task, time - 1}}
    end)
  end

  def resolve_all(work, completed_tasks) do
    {completed_tasks, work}
  end

  def resolve_all({[], work}) do
    work
  end

  def resolve_all({[head | tail], work}) do
    remaining_work = resolve(work, head)
    {tail, remaining_work}
  end

  def clear_completed_work(progress, completed) do
    completed_tasks =
      progress
      |> Enum.filter(fn {_worker, {_task, time}} -> time == 0 end)
      |> Enum.map(fn {_worker, {task, _time}} -> task end)

    updated_progress =
      progress
      |> Enum.filter(fn {_worker, {_task, time}} -> time != 0 end)
      |> Map.new()

    {updated_progress, completed ++ completed_tasks}
  end

  def who_needs_work(progress, w) do
    all_workers = 1..w |> MapSet.new()
    busy_workers = Map.keys(progress) |> MapSet.new()
    MapSet.difference(all_workers, busy_workers) |> MapSet.to_list()
  end

  def make_assignments(free_workers, progress, work) do
    make_assignments({free_workers, progress, work})
  end

  def make_assignments({[], progress, work}) do
    {progress, work}
  end

  def make_assignments({[head | tail], progress, work}) do
    assignment = List.first(work)

    if assignment == nil do
      {[], progress, work}
    else
      next_progress = Map.put(progress, head, {assignment, letter_step_time(assignment)})
      [_ | next_work] = work
      make_assignments({tail, next_progress, next_work})
    end
  end

  def assign_work({progress, completed}, w, work) do
    free_workers = who_needs_work(progress, w)
    {next_progress, next_work} = make_assignments(free_workers, progress, work)
    {next_progress, completed, next_work}
  end

  def parallel(list, w) do
    dependencies = all_dependencies(list)

    parallel(%{workers: w, work: dependencies, completed: [], progress: %{}, step: -1})
  end

  def parallel(%{work: [], progress: m, step: step}) when m == %{} do
    step
  end

  def parallel(%{
        workers: w,
        work: work,
        completed: completed,
        progress: progress,
        step: step
      }) do
    next_step = step + 1

    {next_progress, next_completed, next_work} =
      update_progress(progress)
      |> clear_completed_work(completed)
      |> assign_work(w, work)

    IO.inspect(%{
      workers: w,
      completed: next_completed,
      progress: next_progress,
      work: next_work,
      step: next_step
    })

    parallel(%{
      workers: w,
      completed: next_completed,
      progress: next_progress,
      work: next_work,
      step: next_step
    })
  end
end
