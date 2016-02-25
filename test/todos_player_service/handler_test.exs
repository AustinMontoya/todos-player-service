defmodule TodosPlayerService.HandlerTest do
  use ExUnit.Case

  alias TodosPlayerService.{Models, Handler, Database}

  test "New player defaults" do
    player = Models.Player.new()
    assert player.xp == 0
    assert player.level == 1
    assert player.completed_todos == []
  end

  test "Completing a todo" do
    %{ id: player_id } = Database.post!(Models.Player.new)
    :ok = Handler.todo_completed(player_id, "0")

    player = Database.get!(player_id)
    assert player.xp == 10
    assert player.level == 1
    assert player.completed_todos == ["0"]

    Enum.each(1..9, fn i -> Handler.todo_completed(player_id, Integer.to_string(i)) end)
    player = Database.get!(player_id)
    assert player.xp == 0
    assert player.level == 2
    assert player.completed_todos == Enum.map(9..0, &Integer.to_string/1)
  end

end
