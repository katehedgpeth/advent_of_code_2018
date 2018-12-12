defmodule AdventOfCode.Day3 do
  def question_1(input) do
    {_, overlaps} =
      input
      |> parse_claims()
      |> Enum.reduce({%{}, MapSet.new()}, &check_for_overlap/2)

    MapSet.size(overlaps)
  end

  def question_2(input) do
    claims =
      input
      |> parse_claims()
      |> Enum.into([])

    {grid, _} = Enum.reduce(claims, {%{}, MapSet.new()}, &check_for_overlap/2)

    {id, _} = Enum.find(claims, &intact?(&1, grid))

    id
  end

  defp parse_claims(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_claim/1)
  end

  defp parse_claim(claim) do
    [id, rest] = String.split(claim, " @ ")
    [xy, wh] = String.split(rest, ": ")
    [x, y] = String.split(xy, ",")
    [w, h] = String.split(wh, "x")
    [x, y, w, h] = Enum.map([x, y, w, h], &String.to_integer/1)
    {id, rectangle_to_points(x, y, w, h)}
  end

  defp check_for_overlap({id, points}, {grid, overlaps}) do
    Enum.reduce(points, {grid, overlaps}, &check_point_for_overlap(&1, &2, id))
  end

  def rectangle_to_points(x, y, w, h) do
    0
    |> Range.new(w - 1)
    |> Stream.map(&(&1 + x))
    |> Enum.reduce([], &build_rectangle_row(&1, &2, y, h))
  end

  defp build_rectangle_row(x, acc, y, h) do
    0
    |> Range.new(h - 1)
    |> Stream.map(&(&1 + y))
    |> Enum.reduce(acc, &build_point(x, &1, &2))
  end

  defp build_point(x, y, acc) do
    [{x, y} | acc]
  end

  defp check_point_for_overlap({x, y}, {grid, overlaps}, id) do
    grid
    |> Map.update(x, %{y => [id]}, &update_grid_point(&1, y, id))
    |> update_overlaps(overlaps, {x, y})
  end

  defp update_grid_point(row, y, id) do
    Map.update(row, y, [id], &[id | &1])
  end

  defp update_overlaps(grid, overlaps, {x, y}) do
    grid
    |> Map.get(x)
    |> Map.get(y)
    |> do_update_overlaps({x, y}, grid, overlaps)
  end

  defp do_update_overlaps([_], _point, grid, overlaps) do
    {grid, overlaps}
  end

  # refactoring opportunity: make overlap update optional
  defp do_update_overlaps([_, _ | _], point, grid, overlaps) do
    {grid, MapSet.put(overlaps, point)}
  end

  defp intact?({_id, []}, _grid) do
    true
  end

  defp intact?({id, [{x, y} | rest]}, grid) do
    grid
    |> Map.get(x)
    |> Map.get(y)
    |> case do
      [^id] -> intact?({id, rest}, grid)
      _ -> false
    end
  end
end
