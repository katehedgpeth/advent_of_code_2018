defmodule AdventOfCode.Day7Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day7

  @test_input """
  Step C must be finished before step A can begin.
  Step C must be finished before step F can begin.
  Step A must be finished before step B can begin.
  Step A must be finished before step D can begin.
  Step B must be finished before step E can begin.
  Step D must be finished before step E can begin.
  Step F must be finished before step E can begin.
  """

  test "question_1" do
    {:ok, io} = StringIO.open(@test_input)

    assert io
           |> IO.stream(:line)
           |> Day7.question_1() == 'CABDFE'

    input =
      :advent_of_code
      |> Application.app_dir("priv/day_7.txt")
      |> File.stream!([], :line)

    assert Day7.question_1(input) == 'ABLCFNSXZPRHVEGUYKDIMQTWJO'
  end

  test "question_2" do
    {:ok, io} = StringIO.open(@test_input)

    assert io
           |> IO.stream(:line)
           |> Day7.question_2([:john, :paul], 0) == 15

    input =
      :advent_of_code
      |> Application.app_dir("priv/day_7.txt")
      |> File.stream!([], :line)

    assert Day7.question_2(input, [:john, :paul, :george, :ringo, :pete], 60) == 1157
  end
end
