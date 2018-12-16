defmodule AdventOfCode.Day6.Question2 do
  alias AdventOfCode.Day6

  def solve([{_x, _y} | _] = coords, max_distance) do
    {x_range, y_range} = find_boundaries(coords)

    for x <- x_range,
        y <- y_range,
        point = {x, y},
        sum_of_distance_from_coordinates(point, coords) < max_distance,
        do: point
  end

  defp sum_of_distance_from_coordinates({_x, _y} = point, coords) do
    coords
    |> Enum.map(&Day6.manhattan_distance(point, &1))
    |> Enum.sum()
  end

  def find_boundaries(coords) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(coords, fn {x, _y} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(coords, fn {_x, y} -> y end)

    {
      min_x..max_x,
      min_y..max_y
    }
  end
end
