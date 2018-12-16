defmodule AdventOfCode.Day6Test do
  use ExUnit.Case, async: true
  alias AdventOfCode.Day6
  doctest Day6

  @test_coords [
    {1, 1},
    {1, 6},
    {8, 3},
    {3, 4},
    {5, 5},
    {8, 9}
  ]

  @input [
    {292, 73},
    {204, 176},
    {106, 197},
    {155, 265},
    {195, 59},
    {185, 136},
    {54, 82},
    {209, 149},
    {298, 209},
    {274, 157},
    {349, 196},
    {168, 353},
    {193, 129},
    {94, 137},
    {177, 143},
    {196, 357},
    {272, 312},
    {351, 340},
    {253, 115},
    {109, 183},
    {252, 232},
    {193, 258},
    {242, 151},
    {220, 345},
    {336, 348},
    {196, 203},
    {122, 245},
    {265, 189},
    {124, 57},
    {276, 204},
    {309, 125},
    {46, 324},
    {345, 228},
    {251, 134},
    {231, 117},
    {88, 112},
    {256, 229},
    {49, 201},
    {142, 108},
    {150, 337},
    {134, 109},
    {288, 67},
    {297, 231},
    {310, 131},
    {208, 255},
    {246, 132},
    {232, 45},
    {356, 93},
    {356, 207},
    {83, 97}
  ]

  test "find_boundaries" do
    assert Day6.Question1.find_boundaries(@test_coords) == {1..8, 1..9}
    assert Day6.Question2.find_boundaries(@test_coords) == {1..8, 1..9}
    assert Day6.Question1.find_boundaries(@input) == {54..351, 82..340}
    assert Day6.Question2.find_boundaries(@input) == {46..356, 45..357}
  end

  test "closest_point_map" do
    # A = {1, 1}
    # B = {3, 3}
    # . = equidistant

    # A a .
    # a . b
    # . b B

    assert Day6.Question1.closest_point_map([{1, 1}, {3, 3}], 1..3, 1..3) == %{
             {1, 1} => :self,
             {1, 2} => {1, 1},
             {1, 3} => :equidistant,
             {2, 1} => {1, 1},
             {2, 2} => :equidistant,
             {2, 3} => {3, 3},
             {3, 1} => :equidistant,
             {3, 2} => {3, 3},
             {3, 3} => :self
           }
  end

  test "question_1" do
    assert Day6.question_1(@test_coords) == 17
    assert Day6.question_1(@input) == 4976
  end

  test "question_2" do
    assert @test_coords |> Day6.question_2(32) |> length() == 16
    assert @input |> Day6.question_2(10000) |> length() == 46462
  end
end
