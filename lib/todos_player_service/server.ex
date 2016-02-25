defmodule TodosPlayerService.Server do
  @config Application.get_env(:todos_player_service, TodosPlayerService.Server)

  use Riffed.Server,
  service: :todos_player_service_thrift,
  structs: TodosPlayerService.Models,
  functions: [createPlayer: &TodosPlayerService.Handler.create_player/0,
              todoCompleted: &TodosPlayerService.Handler.todo_completed/2,
              getPlayer: &TodosPlayerService.Handler.get_player/1],
  server: @config[:server]
end
