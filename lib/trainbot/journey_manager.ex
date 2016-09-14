defmodule Trainbot.JourneyManager do
  use HTTPoison.Base
  use Timex
  use Application
  import Ecto.Query

  @tz "Europe/Paris"
  @dateformat "%Y%m%dT%H%M%S"
  @export_format "%kh%M"
  @api_key Application.get_env(:trainbot, Trainbot.Slack)[:sncf_key]

  def extract_journey_from_message(message) do
    splits = String.split(message, " ")
    IO.inspect extract_journey_from_list(splits, %{:name => "", :from => "", :to => ""}, "name")
  end

  defp extract_journey_from_list([head | tail], data, key) do
    if String.contains?(head, "\"") do
      sanitized = String.replace(head, "\"", "", [])
      case key do
        "name" -> extract_journey_from_list(tail, %{data | "#{key}": sanitized}, "from")
        "from" -> extract_journey_from_list(tail, %{data | "#{key}": sanitized}, "to")
        "to" -> %{data | "#{key}": sanitized}
      end
    else
      extract_journey_from_list(tail, data, key)
    end
  end

  defp extract_journey_from_list([], data, key) do
    data
  end

  def save(slack_id, team, name, from, to) do
    journey = %Trainbot.Journey{:slack_id => slack_id, :team => team, :name => name, :from => from, :to => to}
    Trainbot.Repo.insert(journey)
  end

  def list(slack_id, team) do
    Ecto.Query.from(j in Trainbot.Journey, where: j.slack_id == ^slack_id and j.team == ^team) |> Trainbot.Repo.all
  end

  def find_one_by_name(slack_id, team, name) do
    Ecto.Query.from(j in Trainbot.Journey, where: j.slack_id == ^slack_id and j.team == ^team and j.name == ^name) |> Trainbot.Repo.one
  end

  def format_list([head | tail], message) do
    message <> "\n#{head.name} de #{head.from} à #{head.to}"
  end

  def format_list([], message) do
    message
  end

  def delete(slack_id, team, name) do
    j = find_one_by_name(slack_id, team, name)
    Trainbot.Repo.delete(j)
  end

  def get_response(journey, message) do 
    if journey == nil do
      Trainbot.Answer.get_unknow_journey(message)
    else
      time = Timex.format!(Timex.now, @dateformat, :strftime)
      trips = Trainbot.SNCF.get_journeys(journey.from, journey.to, time, 3) 
      process(trips, "<@#{message.user}> Voici la liste des trains pour aller à #{journey.name}:",  0)
    end
  end

  defp match([head |tail], message) do
    if String.contains?(message.text, head.keyword) do
      head
    else
      match(tail, message)
    end
  end

  defp match([], message) do
    nil
  end

  defp update_text(journeys, txt) do
    journey = List.first(journeys)
    departure = Timezone.convert(Timex.parse!(journey["departure_date_time"], @dateformat, :strftime), @tz)
    arrival = Timezone.convert(Timex.parse!(journey["arrival_date_time"], @dateformat, :strftime), @tz)

    txt <> 
    "\n Depart à " <> Timex.format!(departure, @export_format, :strftime) <> 
    " arrivée à " <> 
    Timex.format!(arrival, @export_format, :strftime)
  end

  defp process([head | tail], txt, n) do
    updated_txt = update_text(head["journeys"], txt)      
    process(tail, updated_txt, n+1)
  end

  defp process([], txt, _n) do
    txt
  end

end
