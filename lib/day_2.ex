defmodule AdventOfCode.Day2 do
  def question_1(id_stream) do
    {two, three} =
      id_stream
      |> Stream.map(&letters_to_set/1)
      |> Enum.reduce({0, 0}, &do_question_1/2)

    two * three
  end

  defp do_question_1(count_set, {two, three}) do
    two =
      if MapSet.member?(count_set, 2) do
        two + 1
      else
        two
      end

    three =
      if MapSet.member?(count_set, 3) do
        three + 1
      else
        three
      end

    {two, three}
  end

  def letters_to_set(id) do
    id
    |> String.to_charlist()
    |> Enum.reduce(%{}, fn char, acc -> Map.update(acc, char, 1, &(&1 + 1)) end)
    |> MapSet.new(fn {_, count} -> count end)
  end

  def question_2(id_stream) do
    id_stream
    |> Stream.map(&String.trim/1)
    |> Enum.into([])
    |> find_similar_ids()
    |> find_identical_chars()
  end

  defp find_similar_ids([]) do
    :error
  end

  defp find_similar_ids([id | rest]) do
    case do_find_similar_ids(id, rest) do
      {:ok, id, similar} -> {id, similar}
      :error -> find_similar_ids(rest)
    end
  end

  defp do_find_similar_ids(_id, []) do
    :error
  end

  defp do_find_similar_ids(id, [next | rest]) do
    case similar_id?(id, next) do
      :error -> do_find_similar_ids(id, rest)
      :ok -> {:ok, id, next}
    end
  end

  def similar_id?(left, right) do
    left_charlist = String.to_charlist(left)
    right_charlist = String.to_charlist(right)

    left_charlist
    |> Enum.zip(right_charlist)
    |> Enum.reduce_while(0, &compare_chars/2)
    |> case do
      1 -> :ok
      _ -> :error
    end
  end

  # If character is the same, return the accumulator without incrementing.
  # If character is different but accumulator is less than 2, increment the accumumlator by 1.
  # If the accumulator reaches 2, the IDs aren't a match, so halt the reducer.
  def compare_chars({char, char}, acc) do
    {:cont, acc}
  end

  def compare_chars({_, _}, acc) do
    case acc + 1 do
      2 -> {:halt, :error}
      new_acc -> {:cont, new_acc}
    end
  end

  defp find_identical_chars({left, right}) do
    left = String.graphemes(left)
    right = String.graphemes(right)

    left
    |> Enum.zip(right)
    |> Enum.reduce("", fn
      {char, char}, acc -> acc <> char
      _, acc -> acc
    end)
  end
end
