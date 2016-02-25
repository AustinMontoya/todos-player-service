defmodule TodosPlayerService do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    [couch_url: couch_url,
     database_name: database_name
    ] = Application.get_env(:todos_player_service, TodosPlayerService.Database)

    children = [
      worker(TodosPlayerService.Server, []),
      Plug.Adapters.Cowboy.child_spec(:http, TodosPlayerService.HttpRouter, []),
      worker(TodosPlayerService.Handler, []),
      worker(TodosPlayerService.Database, [couch_url, database_name])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TodosPlayerService]
    Supervisor.start_link(children, opts)
  end
end
