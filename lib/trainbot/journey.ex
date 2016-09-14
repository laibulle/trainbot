defmodule Trainbot.Journey do
  use Ecto.Schema

  schema "journey" do
    field :team, :string
    field :slack_id, :string
    field :name, :string
    field :from, :string
    field :from_name, :string
    field :to, :string
    field :to_name, :string
  end
end
