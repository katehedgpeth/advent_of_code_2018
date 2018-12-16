defmodule AdventOfCode.Day7 do
  alias __MODULE__.Question1
  alias __MODULE__.Question2

  def question_1(input) do
    input
    |> Enum.reduce({%{}, %{}}, &parse_line/2)
    |> Question1.get_dependency_order()
  end

  def question_2(input, workers, task_length) do
    {priors, deps} = Enum.reduce(input, {%{}, %{}}, &parse_line/2)

    Question2.get_total_time(
      deps: deps,
      priors: priors,
      workers: workers,
      task_length: task_length
    )
  end

  # prior_steps is a map of which steps are preventing each step from being available.
  # dependencies is a map of which steps are dependent on each step being completed.

  # prior_steps will be used to determine if a step is ready to be started
  # dependencies will be used to update the prior_steps hash once a step is completed.

  # Given the following data:
  # A must be finished before B can begin.
  # A must be finished before C can begin.
  # B must be finished before D can begin.

  # prior_steps would be: %{
  #   A => [],
  #   B => [A],
  #   C => [A],
  #   D => [B]
  # }

  # dependencies would be: %{
  #   A => [B, C],
  #   B => [D],
  #   C => [],
  #   D => []
  # }

  defp parse_line(
         <<"Step ", before::utf8, " must be finished before step ", after_::utf8, " can begin">> <>
           _,
         {prior_steps, dependencies}
       ) do
    prior_steps =
      prior_steps
      |> Map.put_new(before, MapSet.new())
      |> Map.update(after_, MapSet.new([before]), &MapSet.put(&1, before))

    dependencies =
      dependencies
      |> Map.put_new(after_, MapSet.new())
      |> Map.update(before, MapSet.new([after_]), &MapSet.put(&1, after_))

    {prior_steps, dependencies}
  end

  def free_dependencies(step, prior_steps, dependencies) do
    # remove this step from the maps
    {step_dependencies, dependencies} = Map.pop(dependencies, step)
    {_, prior_steps} = Map.pop(prior_steps, step)

    # remove this step from all of this step's dependencies' priors
    {prior_steps, _} = Enum.reduce(step_dependencies, {prior_steps, step}, &free_dependency/2)

    {prior_steps, dependencies}
  end

  defp free_dependency(step, {prior_steps, dependency}) do
    {
      Map.update!(prior_steps, step, &MapSet.delete(&1, dependency)),
      dependency
    }
  end
end
