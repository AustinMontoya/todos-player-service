defmodule TodosPlayerService.Database do

  def start_link(couch_url, database_name) do
    db_url = Path.join(couch_url, database_name)
    Agent.start_link(fn -> {db_url} end, name: __MODULE__)
  end

  def get!(player_id) do
    resource_url(player_id)
      |> HTTPoison.get!()
      |> process_response_body()
  end

  def put!(player_id, updates) do
    data = get!(player_id)
      |> Map.merge(updates)
      |> Poison.encode!()

    result = resource_url(player_id)
      |> HTTPoison.put!(data)
      |> process_response_body()

    %{ rev: result.rev }
  end

  def post!(data) do
    request_data = Poison.encode!(data)
    result = resource_url
        |> HTTPoison.post!(request_data, [{"Content-Type", "application/json"}])
        |> process_response_body()

    Map.merge(data, %{ id: result.id, rev: result.rev })
  end

  def resource_url(path \\ "") do
    Agent.get(__MODULE__, fn {db_url} -> Path.join(db_url, path) end)
  end

  defp process_response_body(%{ body: body }) do
    case Poison.decode!(body) do
      %{"error" => err, "reason" => reason} -> raise "Couch error: #{err}: #{reason}"
      payload -> map_keys_to_atoms(payload)
    end
  end

  defp map_keys_to_atoms(map) do
    map
    |> Enum.reduce(%{}, fn ({key, val}, acc) -> Map.put(acc, String.to_atom(key), val) end)
  end
end
