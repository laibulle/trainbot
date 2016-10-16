defmodule Trainbot.Journey do
  use Ecto.Schema
  import Ecto.Changeset

  schema "journey" do
    field :slack_id, :string
    field :name, :string
    field :from, :string
    field :from_name, :string
    field :to, :string
    field :to_name, :string
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:slack_id, :name, :from, :from_name, :to, :to_name])
    |> validate_required([:slack_id, :name, :from, :to])
    |> unique_constraint(:slack_id_name)
  end
end
