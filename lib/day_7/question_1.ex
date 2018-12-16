defmodule AdventOfCode.Day7.Question1 do
  alias AdventOfCode.Day7

  def get_dependency_order({prior_steps, dependencies}) do
    finish_free_steps({prior_steps, dependencies}, [])
  end

  defp finish_free_steps({priors, deps}, acc) when priors == %{} and deps == %{} do
    Enum.reverse(acc)
  end

  defp finish_free_steps({prior_steps, dependencies}, acc) do
    prior_steps
    |> Enum.reduce([], &find_free_step/2)
    |> Enum.sort()
    |> case do
      [] ->
        # if there are no more free steps, we are finished.
        # reverse the charlist accumulator so the steps are in the right order.
        Enum.reverse(acc)

      [next_step | _] ->
        # otherwise, update the accumulators and try again.
        {prior_steps, dependencies, acc} =
          finish_step_and_free_dependencies(next_step, prior_steps, dependencies, acc)

        finish_free_steps({prior_steps, dependencies}, acc)
    end
  end

  defp find_free_step({letter, priors_for_letter}, acc) do
    if MapSet.size(priors_for_letter) == 0 do
      [letter | acc]
    else
      acc
    end
  end

  defp finish_step_and_free_dependencies(step, prior_steps, dependencies, acc) do
    # update the string accumulator, since this step is now out of the running
    acc = [step | acc]

    {prior_steps, dependencies} = Day7.free_dependencies(step, prior_steps, dependencies)

    {prior_steps, dependencies, acc}
  end
end
