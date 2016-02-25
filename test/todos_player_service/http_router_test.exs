defmodule TodosPlayerService.HttpRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias TodosPlayerService.{HttpRouter, Database, Models}

  @opts HttpRouter.init([])

  test "GET /players/:id" do
    player = Models.Player.new(%{level: 10, xp: 200, completed_todos: ["123"]})
    %{ id: player_id } = Database.post!(player)

    conn = conn(:get, "/players/#{player_id}")
    conn = HttpRouter.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200

    body = Poison.decode!(conn.resp_body)
    assert body["id"] == player_id
    assert body["level"] == 10
    assert body["xp"] == 200
    assert body["completed_todos"] == ["123"]
  end

  test "POST /players" do
    conn = conn(:post, "/players")
    conn = HttpRouter.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 203

    %{ "id" => player_id } = Poison.decode!(conn.resp_body)
    player = Database.get!(player_id)
    assert player.level == 1
    assert player.xp == 0
    assert player.completed_todos == []
  end

  test "POST /players/completed_todos" do
    %{ id: player_id } = Database.post!(Models.Player.new)

    conn = conn(:post, "/players/#{player_id}/completed_todos", Poison.encode!(%{id: "abcd"}))
        |> put_req_header("content-type", "application/json")
    conn = HttpRouter.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 203

    player = Database.get!(player_id)
    assert player.completed_todos == ["abcd"]
  end
end
