defmodule TodosPlayerService.HttpRouter do
  use Plug.Router
  alias TodosPlayerService.{Handler, Models}

  if Mix.env == :dev do
    use Plug.Debugger, otp_app: :todos_player_service
  end

  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  post "/players" do
    response = Handler.create_player
    send_resp(conn, 203, Poison.encode!(%{ id: response.id }))
  end

  post "/players/:player_id/completed_todos" do
    %{ "id" => todo_id } = conn.params
    :ok = Handler.todo_completed(player_id, todo_id)
    send_resp(conn, 203, "")
  end

  get "/players/:player_id" do
    player = Handler.get_player(player_id)
    send_resp(conn, 200, Poison.encode!(player))
  end


end
