defmodule Trainbot.JourneyManager do
  use HTTPoison.Base
  use Timex
  use Application
  import Ecto.Query

  alias Trainbot.Journey
  alias Trainbot.Repo

  @tz "Europe/Paris"
  @dateformat "%Y%m%dT%H%M%S"
  @export_format "%kh%M"
  @api_key Application.get_env(:trainbot, Trainbot.Slack)[:sncf_key]

  def save(slack_id, team, name, from, to) do
    changeset = Journey.changeset(
      %Journey{},
      %{:slack_id => slack_id, :team => team, :name => name, :from => from, :to => to}
    )
    
    case Repo.insert(changeset) do
      {:error, error} ->
        IO.puts 'blablhlrenfjenflerjnfkl'
        {:error, error}
      trainbot -> trainbot
    end
  end

  def list(slack_id, team) do
    Ecto.Query.from(j in Trainbot.Journey, where: j.slack_id == ^slack_id and j.team == ^team) |> Trainbot.Repo.all
  end

  def find_one_by_name(slack_id, team, name) do
    Ecto.Query.from(j in Trainbot.Journey, where: j.slack_id == ^slack_id and j.team == ^team and j.name == ^name) |> Trainbot.Repo.one
  end

  def format_list([head | _tail], message) do
    message <> "\n#{head.name} de #{head.from} à #{head.to}"
  end

  def format_list([], message) do
    message
  end

  def delete(slack_id, team, name) do
    j = find_one_by_name(slack_id, team, name)
    Trainbot.Repo.delete(j)
  end

  def get_response(journey) do
    time = Timex.format!(Timezone.convert(Timex.now, @tz), @dateformat, :strftime)
    trips = Trainbot.SNCF.get_journeys(journey.from, journey.to, time, 5)
    process(trips, "Voici la liste des trains pour aller à #{journey.name}:",  0)
  end

  defp update_text(journeys, txt) do
    journey = List.first(journeys)
    departure = Timex.parse!(journey["departure_date_time"], @dateformat, :strftime)
    arrival = Timex.parse!(journey["arrival_date_time"], @dateformat, :strftime)

    txt <>
    "\n Départ à " <> Timex.format!(departure, @export_format, :strftime) <>
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
