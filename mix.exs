defmodule Trainbot.Mixfile do
  use Mix.Project

  def project do
    [app: :trainbot,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :slack, :httpoison, :timex, :ecto, :postgrex, :edeliver, :poison, :websocket_client],
     mod: {Trainbot, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:slack, "~> 0.6.0"},
     {:poison, "~> 2.2"},
     {:timex, "~> 3.0"},
     {:ecto, "~> 2.0"},
     {:postgrex, "~> 0.11"},
     {:edeliver, "~> 1.4"},
     {:distillery, "~> 0.9"},
     {:websocket_client, git: "https://github.com/jeremyong/websocket_client"}]
  end
end
