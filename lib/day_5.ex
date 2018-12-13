defmodule AdventOfCode.Day5 do
  def question_1(input) do
    input
    |> parse_chars([])
    |> byte_size()
  end

  defp parse_chars([], parsed) do
    parsed
  end

  defp parse_chars(<<>>, acc) do
    acc
    |> Enum.reverse()
    |> List.to_string()
  end

  defp parse_chars(<<letter_1, rest::binary>>, [letter_2 | acc])
       when abs(letter_1 - letter_2) == 32 do
    parse_chars(rest, acc)
  end

  defp parse_chars(<<letter, rest::binary>>, acc) do
    parse_chars(rest, [letter | acc])
  end

  def question_2(input) do
    ?a..?z
    |> Enum.reduce([], &remove_polymer(input, &1, &2))
    |> Enum.sort_by(fn {_, count} -> count end)
    |> List.first()
    |> elem(1)
  end

  defp remove_polymer(input, char, acc) do
    upcase = char - 32

    result =
      input
      |> String.to_charlist()
      |> Enum.reject(&(&1 == char or &1 == upcase))
      |> List.to_string()
      |> parse_chars([])
      |> String.length()

    [{char, result} | acc]
  end
end
