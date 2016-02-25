defmodule TodosPlayerService.Server do

  use Riffed.Server,
  service: :todos_player_service_thrift,
  structs: TodosPlayerService.Models,
  functions: [todoCompleted: &TodosPlayerService.Handler.todo_completed/2,
              getPlayer: &TodosPlayerService.Handler.get_player/0
  ],
  server: {:thrift_socket_server,
           port: 1337,
           framed: true,
           max: 10_000,
           socket_opts: [
             recv_timeout: 3000,
             keepalive: true]
          }
end
