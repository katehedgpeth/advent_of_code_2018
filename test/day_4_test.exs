defmodule AdventOfCode.Day4Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Day4

  @file_stream :advent_of_code
               |> Application.app_dir("priv/day_4.txt")
               |> File.stream!()

  test "question_1/1" do
    {:ok, io} =
      StringIO.open("""
      [1518-11-01 00:05] falls asleep
      [1518-11-01 00:25] wakes up
      [1518-11-01 00:55] wakes up
      [1518-11-01 23:58] Guard #99 begins shift
      [1518-11-01 00:00] Guard #10 begins shift
      [1518-11-03 00:29] wakes up
      [1518-11-02 00:40] falls asleep
      [1518-11-02 00:50] wakes up
      [1518-11-03 00:24] falls asleep
      [1518-11-01 00:30] falls asleep
      [1518-11-04 00:02] Guard #99 begins shift
      [1518-11-04 00:36] falls asleep
      [1518-11-04 00:46] wakes up
      [1518-11-03 00:05] Guard #10 begins shift
      [1518-11-05 00:03] Guard #99 begins shift
      [1518-11-05 00:45] falls asleep
      [1518-11-05 00:55] wakes up
      """)

    assert io
           |> IO.stream(:line)
           |> Day4.question_1() == 240

    assert Day4.question_1(@file_stream) == 0
  end

  describe "build_times/2" do
    test "fills in minutes between actions" do
      # [1518-11-01 00:05] falls asleep
      date = "1518-11-01"
      action = {date, 5, "falls asleep\n"}
      store = {{"#10", date}, []}

      assert Day4.build_times(action, [store]) ==
               [
                 {
                   {"#10", date},
                   [
                     {5, :asleep},
                     {4, :awake},
                     {3, :awake},
                     {2, :awake},
                     {1, :awake},
                     {0, :awake}
                   ]
                 }
               ]
    end
  end
end
