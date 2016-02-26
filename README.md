# TodosPlayerService

This is intended to be a companion service, expanding on the idea of [todos-backend-couchdb](https://github.com/grrizzly/todos-backend-couchdb). It implements a  service for managing players, similar to (albeit much more simplified) a character in the popular productivity app [Habitica](https://habitica.com).

In addition to the REST interface (described below), this service also works with Thrift using the binary protocol over TCP. Please see the `thrift/` folder for the contract (for now).

## Quickstart

1. Install the [Docker engine](https://www.docker.com/) and make sure it's running
1. Clone the repo and run:
```shell
> git clone https://github.com/grrizzly/todos-player-service
> cd todos-player-service
> docker-compose up
```

The REST API is now available at your docker host IP, port 4000.

The TCP Thrift API is available at your docker host IP, port 1337.

## REST API

The app listens for HTTP on port 4000.

#### `GET /players/:id`

Fetches a player with the given id.

**Returns**
```json
{
  "id": "f27bb9a1f5e9d39bd8f90044c0017d4b",
  "level": 1,
  "xp": 100,
  "completed_todos": ["xfz07b"]
}
```

### `POST /players`

Creates a new player

**Returns**
```json
{
  "id": "f27bb9a1f5e9d39bd8f90044c0017d4b"
}
```

### `POST /players/:id/completed_todos`

Adds a todo to the list of completed todos for the player and rewards them with a small amount of experience. If the new xp total is greater than the required amount for the next level, the level will be increased. For example, if the player is level 1 (requires 100XP to level 2) and has 90XP, calling this method will increase the level to 2 and reset the XP back to 0.

**Params**
```json
{
  "id": "xfz07b"
}
```

**Response**

Empty (200 status code represents success)

## Installation

1. Install [Elixir](https://elixir-lang.org)
1. Install couchdb and make sure it's running
1. Create a user named `todoService` and password `password`
1. Create a database named `players`
1. Clone this repo and run:
```shell
git clone https://github.com/grrizzly/todos-player-service
cd todos-player-service
mix deps.get
iex -S mix
```

This will start the app and console. From there, you can try out the various modules:

```shell
> TodosPlayerService.Database.post!(TodosPlayerService.Models.new)
%{ id: "afe8820a02fa0f202f", version: "ae92d7fa232ae14cfdb"}

> TodosPlayerService.Client.start_link
:ok

> TodosPlayerService.Client.todoCompleted("afe8820a02fa0f202f", "someFakeId")
:ok
```

## Running the tests

```
mix test
```

The database must be running for the tests to work.
