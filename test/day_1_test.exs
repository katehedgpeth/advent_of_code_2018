defmodule AdventOfCode.Day1Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Day1

  @file_stream :advent_of_code
               |> Application.app_dir("priv/day_1.txt")
               |> File.stream!([], :line)

  test "test_1/0" do
    {:ok, io} =
      StringIO.open("""
      1
      1
      1
      """)

    assert io
           |> IO.stream(:line)
           |> Day1.question_1() == 3

    assert Day1.question_1(@file_stream) == 533
  end

  test "test_2/0" do
    assert Day1.question_2(@file_stream) == 73272
  end
end
