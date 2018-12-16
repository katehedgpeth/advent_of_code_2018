defmodule AdventOfCode.Day7.Question2 do
  alias AdventOfCode.Day7

  def get_total_time(
        deps: %{} = deps,
        priors: %{} = priors,
        workers: free,
        task_length: task_length
      ) do
    tick(%{
      second: 0,
      task_length: task_length,
      tasks_in_flight: [],
      free: free,
      occupied: [],
      priors: priors,
      deps: deps
    })
  end

  def tick(%{priors: priors, deps: deps, second: second}) when priors == %{} and deps == %{} do
    second - 1
  end

  def tick(args) do
    args
    |> remove_finished_tasks()
    |> assign_available_tasks()
    |> Map.update!(:second, &(&1 + 1))
    |> tick()
  end

  defp remove_finished_tasks(args) do
    {still_in_flight, finished} =
      Enum.reduce(args.tasks_in_flight, {[], []}, &get_finished_tasks(args.second, &1, &2))

    args = Map.put(args, :tasks_in_flight, still_in_flight)

    case finished do
      [] -> args
      finished -> remove_finished_task(finished, args)
    end
  end

  defp get_finished_tasks(second, %{finished_at: second} = task, {in_flight, finished}) do
    {in_flight, [task | finished]}
  end

  defp get_finished_tasks(_second, task, {in_flight, finished}) do
    {[task | in_flight], finished}
  end

  defp get_finished_tasks(_second, %{}, acc), do: acc

  defp remove_finished_task([], args) do
    args
  end

  defp remove_finished_task(
         [%{name: name, assigned_to: worker, finished_at: second} | rest],
         %{second: second} = args
       ) do
    {%{} = priors, %{} = deps} = Day7.free_dependencies(name, args.priors, args.deps)
    free = [worker | args.free]
    occupied = Enum.reject(args.occupied, &(&1 == worker))

    remove_finished_task(rest, %{
      args
      | priors: priors,
        deps: deps,
        free: free,
        occupied: occupied
    })
  end

  defp remove_finished_task([_task | rest], args) do
    # task.finished_at doesn't match current second, so it's not finished
    remove_finished_task(rest, args)
  end

  defp assign_available_tasks(args) do
    args.priors
    |> Enum.reduce([], &find_free_task/2)
    |> Enum.sort()
    |> assign_available_task(args)
  end

  defp find_free_task({letter, priors_for_letter}, acc) do
    if MapSet.size(priors_for_letter) == 0 do
      [letter | acc]
    else
      acc
    end
  end

  defp assign_available_task(_, %{free: []} = args) do
    # no workers available
    args
  end

  defp assign_available_task([], args) do
    # no more tasks to assign
    args
  end

  defp assign_available_task([task_name | other_tasks], %{free: [worker | free_workers]} = args) do
    task = %{
      name: task_name,
      assigned_to: worker,
      finished_at: calculate_finish_time(task_name, args)
    }

    args =
      args
      |> Map.update!(:tasks_in_flight, &[task | &1])
      |> Map.update!(:occupied, &[worker | &1])
      |> Map.update!(:priors, &(&1 |> Map.pop(task_name) |> elem(1)))
      |> Map.put(:free, free_workers)

    assign_available_task(other_tasks, args)
  end

  defp calculate_finish_time(codepoint, %{second: second, task_length: task_length}) do
    codepoint - 64 + second + task_length
  end
end
