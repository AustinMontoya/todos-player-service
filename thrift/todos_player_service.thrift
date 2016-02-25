struct Player {
  1: i32 xp=0,
  2: i32 level=1,
  3: list<string> completed_todos=[],
  4: string id
}

service TodosPlayerService {
  Player createPlayer();
  Player getPlayer(1:string playerId);
  void todoCompleted(1:string playerId, 2:string todoId);
}
