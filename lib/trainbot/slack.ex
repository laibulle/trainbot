defmodule Trainbot.Slack do
  use Slack
  use Application

  def handle_message(message = %{type: "message"}, slack, state) do
    # TODO find a better way to match commands
    if String.contains?(message.text, "help") or String.contains?(message.text, "aide") do
      send_message("<@#{slack.me.id}> Oui...", message.channel, slack)
      :timer.sleep(3000)
      send_message("<@#{slack.me.id}> Ba non !", message.channel, slack)
    else 
      if String.contains?(message.text, "enregistre") do
        data = Trainbot.JourneyManager.extract_journey_from_message(message.text)
        from = data[:from]
        to = data[:to]
        name = data[:name]
        Trainbot.JourneyManager.save(slack.me.id, "", name, from, to)
        send_message("<@#{slack.me.id}> J'y travaille", message.channel, slack)
      else
        if String.contains?(message.text, "supprime") do
          Trainbot.JourneyManager.delete(slack.me.id, "", "")
          send_message("<@#{slack.me.id}> Bientôt", message.channel, slack)
        else
          if String.contains?(message.text, "liste") do
            journeys = Trainbot.JourneyManager.list(slack.me.id, "")
            send_message(Trainbot.JourneyManager.format_list(journeys, "<@#{slack.me.id}> Voici la liste de tes trajets:"), message.channel, slack)
          else
            journey = Trainbot.JourneyManager.find_one_by_name(slack.me.id, "", message_content(String.split(message.text, " ")))
            
            if journey == nil do
              send_message("<@#{slack.me.id}>Tu n'as pas de trajet enregistré.", message.channel, slack)
            else
              txt = Trainbot.JourneyManager.get_response(journey, message)
              send_message(txt, message.channel, slack)
            end
          end
        end
      end
    end

    {:ok, state}
  end

  def message_content([head | tail]) do
    Enum.join(tail)
  end
  
  # Catch all message handler so we don't crash
  def handle_message(_message, _slack, state) do
    {:ok, state}
  end

end
