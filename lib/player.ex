defmodule TodosPlayerService.Player do
  @xp_per_task_completed 10

  defstruct [
    xp: 0,
    level: 1,
    completed_todos: []
  ]

  def task_completed(%__MODULE__{ xp: xp, level: level } = player) do
    new_xp = @xp_per_task_completed + xp
    required_xp = xp_to_next_level(level)
    add_xp(player, required_xp, new_xp)
  end

  def xp_to_next_level(current_level) do
    100 + (@xp_per_task_completed / 100) * (current_level - 1)
  end

  defp add_xp(player, required_xp, new_xp) when new_xp >= required_xp do
    add_xp(
      %{ player | level: player.level + 1 },
      xp_to_next_level(player.level + 1),
      new_xp - required_xp
    )
  end

  defp add_xp(player, _required_xp, new_xp) do
    %{ player | xp: new_xp }
  end
end
