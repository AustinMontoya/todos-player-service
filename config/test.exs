use Mix.Config

config :todos_player_service, TodosPlayerService.Database,
  couch_url: "http://todoService:password@localhost:5984",
  database_name: "players_test"
