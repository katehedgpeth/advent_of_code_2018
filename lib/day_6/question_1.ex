defmodule AdventOfCode.Day6.Question1 do
  @doc """
  Question: given a list of coordinates on an infinite grid, what is the size of the largest area that isn't infinite?
  """
  alias AdventOfCode.Day6

  def solve([{_x, _y} | _] = coords) do
    {x_range, y_range} = find_boundaries(coords)

    closest_point_map = closest_point_map(coords, x_range, y_range)

    closest_point_counts =
      Enum.reduce(closest_point_map, %{}, fn
        {_coord, :equidistant}, acc -> acc
        {coord, :self}, acc -> Map.update(acc, coord, 1, &(&1 + 1))
        {_coord, closest_point}, acc -> Map.update(acc, closest_point, 1, &(&1 + 1))
      end)

    coords
    |> Enum.reject(&infinite?(&1, x_range, y_range))
    |> Enum.reduce(0, &largest_area?(&1, closest_point_counts, &2))
  end

  def closest_point_map(coords, x_range, y_range) do
    for x <- x_range,
        y <- y_range,
        point = {x, y},
        do: {point, find_closest_coord_to_point(point, coords)},
        into: %{}
  end

  defp find_closest_coord_to_point({_x, _y} = point, coordinates) do
    coordinates
    |> Enum.map(fn coord -> {Day6.manhattan_distance(coord, point), coord} end)
    |> Enum.sort()
    |> case do
      # if the manhattan distance is 0, the point is a coordinate so
      # the closest coordinate is itself.
      [{0, _} | _] ->
        :self

      # if the first and second distances are equal, there is no one closest coordinate.
      [{distance, _coord1}, {distance, _coord2} | _] ->
        :equidistant

      # otherwise, the lowest distance is the closest coordinate.
      [{_, closest_coordinate} | _] ->
        closest_coordinate
    end
  end

  @doc """
  A = {1, 2}
  B = {3, 3}
  C = {3, 4}
  D = {1, 4}

  . A . .
  . . . .
  . . B C
  D . . .

    iex> Day6.infinite?({1, 2}, 1..4, 1..4)
    true

    iex> Day6.infinite?({3, 3}, 1..4, 1..4)
    false

    iex> Day6.infinite?({3, 4}, 1..4, 1..4)
    true

    iex> Day6.infinite?({1, 4}, 1..4, 1..4)
    true

  """
  def infinite?({min_x, _y}, min_x.._max_x, _y_range), do: true
  def infinite?({max_x, _y}, _min_x..max_x, _y_range), do: true
  def infinite?({_x, min_y}, _x_range, min_y.._max_y), do: true
  def infinite?({_x, max_y}, _x_range, _min_y..max_y), do: true
  def infinite?({_x, _y}, _x_range, _y_range), do: false

  defp largest_area?({x, y}, closest_point_counts, acc) do
    closest_point_counts
    |> Map.get({x, y})
    |> do_largest_area?(acc)
  end

  defp do_largest_area?(nil, acc) do
    acc
  end

  defp do_largest_area?(count, acc) when is_integer(count) and is_integer(acc) and count > acc do
    count
  end

  defp do_largest_area?(count, acc) when is_integer(count) and is_integer(acc) and count < acc do
    acc
  end

  def find_boundaries(coords) do
    {min_x, min_y} = Enum.min_by(coords, fn {x, y} -> x * y end)
    {max_x, max_y} = Enum.max_by(coords, fn {x, y} -> x * y end)

    {
      min_x..max_x,
      min_y..max_y
    }
  end
end
