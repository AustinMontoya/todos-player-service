defmodule TodosPlayerService.Mixfile do
  use Mix.Project

  def project do
    [app: :todos_player_service,
     compilers: [:thrift | Mix.compilers],
     thrift_files: Mix.Utils.extract_files(["thrift"], [:thrift]),
     erlangrc_options: [{:i, "include"}],
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison, :cowboy, :plug],
    mod: {TodosPlayerService, []}]
  end

  defp deps do
    [{:riffed, github: "pinterest/riffed", tag: "1.0.0", submodules: true},
     {:httpoison, "~> 0.8.0"},
     {:poison, "~> 2.1.0"},
     {:plug, "~> 1.1.2"},
     {:cowboy, "~> 1.0.0"}]
  end
end
