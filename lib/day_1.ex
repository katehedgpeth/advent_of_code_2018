defmodule AdventOfCode.Day1 do
  def question_1(file_stream) do
    file_stream
    |> Stream.map(&line_to_int/1)
    |> Enum.sum()
  end

  def question_2(file_stream) do
    file_stream
    |> Stream.map(&line_to_int/1)
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new()}, &check_for_duplicate/2)
  end

  defp check_for_duplicate(number, {acc, frequencies})
       when is_integer(number) and is_integer(acc) do
    freq = number + acc

    if MapSet.member?(frequencies, freq) do
      {:halt, freq}
    else
      {:cont, {freq, MapSet.put(frequencies, freq)}}
    end
  end

  defp line_to_int(line) do
    {int, _rest} = Integer.parse(line)
    int
  end
end
