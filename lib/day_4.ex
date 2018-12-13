defmodule AdventOfCode.Day4 do
  @guard_hour Map.new(0..59, &{&1, 0})

  def question_1(input) do
    input
    |> Enum.into([])
    |> Enum.sort()
    |> Enum.map(&parse_line/1)
    |> Enum.reduce([], &build_times/2)
    |> Enum.reduce(%{}, &build_guard_hour/2)
    |> Enum.map(&sum_minutes/1)
    |> Enum.sort_by(fn {_id, {sum, _minutes}} -> -sum end)
    |> calculate_question_1()
  end

  defp calculate_question_1([{"#" <> id, {_sum, minutes}} | _]) do
    [{highest_minute, _} | _] = Enum.sort_by(minutes, fn {_, count} -> -count end)

    id_int =
      id
      |> String.trim()
      |> String.to_integer()

    highest_minute * id_int
  end

  defp parse_line("[" <> line) do
    [datetime, action] = String.split(line, "] ")
    [date, time] = String.split(datetime, " ")
    [_hour, minute] = String.split(time, ":")
    {date, String.to_integer(minute), action}
  end

  def build_times({date, _, "Guard " <> id}, acc) do
    [id, _] = String.split(id, "begins")
    [{{id, date}, []} | acc]
  end

  def build_times({date, min, action}, [{{id, _}, actions} | rest]) do
    action = parse_action(action)
    previous_action = if action == :awake, do: :asleep, else: :awake

    actions =
      actions
      |> get_start_minute()
      |> Range.new(min)
      |> Enum.reduce(actions, &add_action(&1, min, {action, previous_action}, &2))

    [{{id, date}, actions} | rest]
  end

  defp get_start_minute([{min, _} | _]), do: min + 1
  defp get_start_minute([]), do: 0

  defp parse_action("falls asleep" <> _), do: :asleep
  defp parse_action("wakes up" <> _), do: :awake

  defp add_action(start_minute, start_minute, {action, _previous_action}, acc) do
    [{start_minute, action} | acc]
  end

  defp add_action(prior_to_start, _start_minute, {_action, previous_action}, acc) do
    [{prior_to_start, previous_action} | acc]
  end

  defp build_guard_hour({{id, _date}, minutes}, acc) do
    guard_hour = Map.get(acc, id, @guard_hour)

    updated = Enum.reduce(minutes, guard_hour, &add_minute_to_hour/2)

    Map.put(acc, id, updated)
  end

  defp add_minute_to_hour({_minute, :awake}, acc) do
    acc
  end

  defp add_minute_to_hour({minute, :asleep}, acc) do
    Map.update!(acc, minute, &(&1 + 1))
  end

  defp sum_minutes({id, minutes}) do
    sum = Enum.reduce(minutes, 0, fn {_, count}, acc -> acc + count end)
    {id, {sum, minutes}}
  end
end
