defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  @example [
    "Step C must be finished before step A can begin.",
    "Step C must be finished before step F can begin.",
    "Step A must be finished before step B can begin.",
    "Step A must be finished before step D can begin.",
    "Step B must be finished before step E can begin.",
    "Step D must be finished before step E can begin.",
    "Step F must be finished before step E can begin."
  ]

  test "Can parse a dependency" do
    result = Day7.parse(@example |> List.first(), %{})
    assert result == %{"A" => MapSet.new(["C"])}
  end

  test "Can process all of the dependencies" do
    result =
      @example
      |> Day7.parse_all()

    assert Map.get(result, "A") == MapSet.new(["C"])
  end

  test "Find steps with no dependencies in starting order" do
    next_dependency =
      @example
      |> Day7.parse_all()
      |> Day7.next_dependency()

    assert next_dependency == "C"
  end

  test "Corner case of multiple resolved dependencies" do
    deps = %{
      "E" => MapSet.new(["B", "D"])
    }

    next_dep =
      deps
      |> Day7.next_dependency()

    assert next_dep == "B"
  end

  test "can resolve a dependency" do
    deps = %{
      "E" => MapSet.new(["B", "D"])
    }

    result = Day7.resolve(deps, "B")

    assert result == %{
             "E" => MapSet.new(["D"])
           }
  end

  test "next D comes off" do
    deps = %{
      "E" => MapSet.new(["D"])
    }

    next_dep =
      deps
      |> Day7.next_dependency()

    assert next_dep == "D"
  end

  test "D can be resolved" do
    deps = %{
      "E" => MapSet.new(["D"])
    }

    result = Day7.resolve(deps, "D")

    assert result == %{
             "E" => MapSet.new()
           }
  end

  test "E is the next dependency" do
    deps = %{
      "E" => MapSet.new()
    }

    next_dep =
      deps
      |> Day7.next_dependency()

    assert next_dep == "E"
  end

  test "full example" do
    result =
      @example
      |> Day7.all_dependencies()

    assert result == ["C", "A", "B", "D", "F", "E"]
  end

  test "the big puzzle" do
    assert Day7.all_data() |> Day7.all_dependencies() |> Enum.join("") ==
             "FMOXCDGJRAUIHKNYZTESWLPBQV"
  end

  test "seconds per letter-step" do
    assert Day7.letter_step_time("C") == 3
  end

  test "how many steps are available right now?" do
    data =
      @example
      |> Day7.parse_all()

    assert Day7.available_dependencies(data) == 1
  end

  test "work progress progresses" do
    progress = %{
      1 => {"C", 3}
    }

    result = Day7.update_progress(progress)

    assert result == [{1, {"C", 2}}]
  end

  test "clears completed work" do
    progress = %{
      1 => {"C", 3},
      2 => {"B", 0}
    }

    {p, c} = Day7.clear_completed_work(progress, ["A"])

    assert p == %{1 => {"C", 3}}
    assert c == ["A", "B"]
  end

  test "tell who needs work" do
    progress = %{
      1 => {"C", 3}
    }

    w = 2

    result = Day7.who_needs_work(progress, w)

    assert result == [2]
  end

  test "starting with two workers and example data" do
    data =
      @example
      |> Day7.all_dependencies()

    result =
      %{offset: 0, workers: 2, completed: [], progress: %{}, work: data, step: 0}
      |> Day7.parallel()

    assert result == {}
  end
end
