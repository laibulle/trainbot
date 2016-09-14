defmodule Trainbot do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    slack_token = Application.get_env(:trainbot, Trainbot.Slack)[:token]
    IO.puts slack_token
    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Trainbot.Worker.start_link(arg1, arg2, arg3)
      worker(Trainbot.Repo, []),
      worker(Trainbot.Slack, [slack_token, :whatever]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Trainbot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
