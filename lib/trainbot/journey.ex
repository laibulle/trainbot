defmodule Trainbot.Journey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "journey" do
    field :team, :string
    field :slack_id, :string
    field :name, :string
    field :from, :string
    field :from_name, :string
    field :to, :string
    field :to_name, :string
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:team, :slack_id, :name, :from, :from_name, :to, :to_name])
    |> unique_constraint(:journey_slack_id_team_name_index)
  end
end
