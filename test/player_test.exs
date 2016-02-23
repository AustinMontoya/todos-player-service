defmodule TodosPlayerService.PlayerTest do
  use ExUnit.Case
  # doctest __MODULE__

  alias TodosPlayerService.Player

  test "New player defaults" do
    player = %Player{}
    assert player.xp == 0
    assert player.level == 1
    assert player.completed_todos == []
  end

  test "Adding xp" do
    player = Player.task_completed(%Player{})
    assert player.xp == 10
    assert player.level == 1

    player = Enum.reduce(1..9, player, fn (_i, p) -> Player.task_completed(p) end)
    assert player.xp == 0
    assert player.level == 2
  end

end
