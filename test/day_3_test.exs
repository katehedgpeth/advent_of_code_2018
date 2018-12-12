defmodule AdventOfCode.Day3Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Day3

  @file_stream :advent_of_code
               |> Application.app_dir("priv/day_3.txt")
               |> File.stream!()

  test "question_1" do
    {:ok, io} =
      StringIO.open("""
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
      """)

    assert io
           |> IO.stream(:line)
           |> Day3.question_1() == 4

    assert Day3.question_1(@file_stream) == 117_505
  end

  test "question_2" do
    {:ok, io} =
      StringIO.open("""
      #1 @ 1,3: 4x4
      #2 @ 3,1: 4x4
      #3 @ 5,5: 2x2
      """)

    assert io
           |> IO.stream(:line)
           |> Day3.question_2() == "#3"

    assert Day3.question_2(@file_stream) == "#1254"
  end

  test "rectangle_to_points" do
    expected = [
      {1, 3},
      {2, 3},
      {3, 3},
      {4, 3},
      {1, 4},
      {2, 4},
      {3, 4},
      {4, 4},
      {1, 5},
      {2, 5},
      {3, 5},
      {4, 5},
      {1, 6},
      {2, 6},
      {3, 6},
      {4, 6}
    ]

    actual = Day3.rectangle_to_points(1, 3, 4, 4)

    assert Enum.sort(expected) == Enum.sort(actual)
  end
end
