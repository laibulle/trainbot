defmodule Trainbot.JourneyController do
  use Slack

  def handle_register(message, slack) do
    case parse_register(message.text) do
      {:ok, data} ->
        case Trainbot.JourneyManager.save(message.user, "", data.name, data.from, data.to) do
          {:error, _} -> send_message(Trainbot.Answer.journey_already_exists(), message.channel, slack)
          {:ok, _} -> send_message(Trainbot.Answer.get_done(), message.channel, slack)
        end
      {:error, data} ->  {:ok, %{}}
    end

    {:ok, %{}}
  end

  def handle_delete(message, slack) do
    case parse_delete(message.text) do
      {:ok, data} ->
        Trainbot.JourneyManager.delete(message.user, "", "")
        send_message(Trainbot.Answer.get_done(), message.channel, slack)
        {:ok, %{}}
      {:error, data} ->  {:ok, %{}}
    end

  end

  def handle_list(message, slack) do
    case parse_list(message.text) do
      {:ok, data} ->
        journeys = Trainbot.JourneyManager.list(message.user, "")
        send_message(Trainbot.JourneyManager.format_list(journeys, "Voici la liste de tes trajets:"), message.channel, slack)
        {:ok, %{}}
      {:error, data} ->  {:ok, %{}}
    end
  end

  def handle_schedule(message, slack) do
    case parse_schedule(message.text) do
      {:ok, data} ->
        journey = Trainbot.JourneyManager.find_one_by_name(message.user, "", data.name)

        case journey do
          nil -> send_message("<@#{message.user}> #{Trainbot.Answer.unknow_journey(data.name)}", message.channel, slack)
          _   ->
            send_message("<@#{message.user}> #{Trainbot.Answer.waiting_sncf()}", message.channel, slack)
            txt = Trainbot.JourneyManager.get_response(journey)
            send_message("<@#{message.user}> #{txt}", message.channel, slack)
        end
      {:error, data} ->  {:ok, %{}}
    end

    {:ok, %{}}
  end

  def parse_schedule(input) do
    list = Regex.run(~r/horaires pour ([a-zA-Z0-9\s]*)./i, input)

    if list != nil do
      {:ok, %{:name => Enum.at(list, 1)}}
    else
      {:error, %{usage: "Horaires pour <nom>."}}
    end
  end

  def parse_register(input) do
    list = Regex.run(~r/enregistre le trajet ([a-zA-Z0-9\s]*) de ([a-zA-Z0-9\s\%]*) à ([a-zA-Z0-9\s\%]*)./i, input)

    if list != nil do
      {:ok, %{:name => Enum.at(list, 1), :from => Enum.at(list, 2), :to => Enum.at(list, 3)}}
    else
      {:error, %{usage: "Enregistre le trajet <nom> de <gare de départ> à <gare d'arrivée>."}}
    end
  end

  def parse_delete(input) do
    list = Regex.run(~r/supprime le trajet ([a-zA-Z\s]*)./i, input)

    if list != nil do
      {:ok, %{:name => Enum.at(list, 1)}}
    else
      {:error, %{usage: "Supprime le trajet <nom>."}}
    end
  end

  def parse_list(input) do
    list = Regex.run(~r/liste mes trajets/i, input)
    {:ok, %{}}
  end

end
