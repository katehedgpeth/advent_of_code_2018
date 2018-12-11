defmodule AdventOfCode.Day2Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Day2

  @file_stream :advent_of_code
               |> Application.app_dir("priv/day_2.txt")
               |> File.stream!([], :line)

  test "letters_to_set" do
    assert Day2.letters_to_set("aabbcdddd") == MapSet.new([1, 2, 4])
  end

  test "question_1" do
    # aabbcdddd -> 2 = true, 3 = false
    # aaabbccd -> 2 = true, 3 = true
    # aabbbdeee -> 2 = true, 3 = true
    # 3 * 2 = 6
    {:ok, io} =
      StringIO.open("""
      aabbcdddd
      aaabbccd
      aabbbdeee
      """)

    assert io
           |> IO.stream(:line)
           |> Day2.question_1() == 6

    assert Day2.question_1(@file_stream) == 6474
  end

  test "question_2" do
    {:ok, io} =
      StringIO.open("""
      abcde
      fghij
      klmno
      pqrst
      fguij
      axcye
      wvxyz
      """)

    assert io
           |> IO.stream(:line)
           |> Day2.question_2() == "fgij"

    assert Day2.question_2(@file_stream) == "mxhwoglxgeauywfkztndcvjqr"
  end

  test "similar_id?" do
    assert Day2.similar_id?("abcde", "abbde") == :ok
    assert Day2.similar_id?("abcde", "edcba") == :error
  end
end
