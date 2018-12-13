defmodule AdventOfCode.Day5Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Day5

  test "question_1" do
    assert Day5.question_1("dabAcCaCBAcCcaDA") == 10

    assert :advent_of_code
           |> Application.app_dir("priv/day_5.txt")
           |> File.read!()
           |> Day5.question_1() == 10132
  end

  test "question_2" do
    assert Day5.question_2("dabAcCaCBAcCcaDA") == 4

    assert :advent_of_code
           |> Application.app_dir("priv/day_5.txt")
           |> File.read!()
           |> Day5.question_2() == 4572
  end
end
