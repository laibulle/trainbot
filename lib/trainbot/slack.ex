defmodule Trainbot.Slack do
  use Slack
  use Application

  def handle_connect(slack) do
    IO.puts "Connected as #{slack.me.name}"
  end

  def handle_message(message = %{type: "message"}, slack) do
      input = message.text
      cond do
        String.match?(input, ~r/enregistre/i) -> Trainbot.JourneyController.handle_register(message, slack)
        String.match?(input, ~r/supprime/i)   -> Trainbot.JourneyController.handle_delete(message, slack)
        String.match?(input, ~r/liste/i)      -> Trainbot.JourneyController.handle_list(message, slack)
        String.match?(input, ~r/horaire/i)    -> Trainbot.JourneyController.handle_schedule(message, slack)
      end
  end

  # Catch all message handler so we don't crash
  def handle_message(_,_), do: :ok
end
