defmodule TodosPlayerService.Handler do
  use GenServer
  alias TodosPlayerService.{Models, Database}

  @xp_per_task_completed 10

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, Keyword.merge(opts, name: __MODULE__))
  end

  def init(:ok) do
    {:ok, nil}
  end

  def get_player(player_id) do
    Database.get!(player_id)
    |> Models.Player.new()
    |> Map.merge(%{id: player_id})
  end

  def create_player() do
    player = Models.Player.new
    %{ id: id } = Database.post!(player)
    %{ player | id: id }
  end

  def todo_completed(player_id, todo_id) do
    player = get_player(player_id)
    new_xp = @xp_per_task_completed + player.xp
    required_xp = xp_to_next_level(player.level)
    player = set_xp(player, required_xp, new_xp)
          |> Map.merge(%{completed_todos: [todo_id | player.completed_todos]})
    Database.put!(player_id, player)
    :ok
  end

  def xp_to_next_level(current_level) do
    100 + (@xp_per_task_completed / 100) * (current_level - 1)
  end

  defp set_xp(player, required_xp, new_xp) when new_xp >= required_xp do
    set_xp(
      %{ player | level: player.level + 1 },
      xp_to_next_level(player.level + 1),
      new_xp - required_xp
    )
  end

  defp set_xp(player, _required_xp, new_xp) do
    %{ player | xp: new_xp }
  end
end
