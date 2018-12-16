defmodule AdventOfCode.Day6 do
  def question_1(coords) do
    __MODULE__.Question1.solve(coords)
  end

  def question_2(coords, max_distance) do
    __MODULE__.Question2.solve(coords, max_distance)
  end

  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
