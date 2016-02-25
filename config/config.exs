use Mix.Config

config :todos_player_service, TodosPlayerService.Server,
  server: {
    :thrift_socket_server,
     port: 1337,
     framed: true,
     max: 10_000,
     socket_opts: [
       recv_timeout: 3000,
       keepalive: true]}

config :todos_player_service, TodosPlayerService.Database,
  couch_url: "http://todoService:password@localhost:5984"

import_config "#{Mix.env}.exs"
