couch_url = "http://todoService:password@localhost:5984"
[couch_url: _url,
 database_name: database_name
] = Application.get_env(:todos_player_service, TodosPlayerService.Database)

HTTPoison.start

%{ body: body } = HTTPoison.get!(Path.join(couch_url, "_all_dbs"))
existing_database = body
  |> Poison.decode!
  |> Enum.find(fn(name) -> name == database_name end)

if existing_database != nil do
  IO.puts("Deleting existing database...")
  HTTPoison.delete!(Path.join(couch_url, database_name))
end

HTTPoison.put!(Path.join(couch_url, database_name), "")

ExUnit.start()
