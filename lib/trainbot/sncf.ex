defmodule Trainbot.SNCF do
  @api_key Application.get_env(:trainbot, Trainbot.Slack)[:sncf_key]

  def get_journeys(from, to, d, n) do
    url = "https://api.sncf.com/v1/coverage/sncf/journeys?to=#{to}&from=#{from}&datetime_represents=departure&datetime=#{d}"
    journey = get_result(url)
    get_journey(from, to, d, [journey], n)
  end

  defp get_journey(from, to, d, journeys, n) do
    if n > 0 do
      previous_journey = List.last(journeys)
      journey = get_result(Enum.at(previous_journey["links"], 0)["href"])
      get_journey(from, to, d, journeys ++ [journey], n - 1)
    else
      journeys      
    end
  end

  defp get_result(url) do
    IO.puts @api_key
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(url, %{}, [hackney: [basic_auth: {@api_key, ""}]])
    Poison.decode!(body)
  end
end
