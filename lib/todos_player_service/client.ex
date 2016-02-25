defmodule TodosPlayerService.Client do
  use Riffed.Client,
  structs: RiffedTutorial.Models,
  client_opts: [
    host: "localhost",
    port: 1337,
    retries: 3,
    framed: true
  ],
  service: :todos_player_service_thrift,
  import: [:todoCompleted]
end
