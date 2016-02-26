use Mix.Config

config :todos_player_service, TodosPlayerService.Database,
  couch_url: System.get_env("TODOS_PLAYER_SERVICE_COUCH_URL"),
  database_name: System.get_env("TODOS_PLAYER_SERVICE_DATABASE_NAME")
