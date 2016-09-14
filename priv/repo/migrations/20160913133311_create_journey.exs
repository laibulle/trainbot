defmodule Trainbot.Repo.Migrations.CreateJourney do
  use Ecto.Migration

  def change do
    create table(:journey) do
      add :team, :string
      add :slack_id, :string
      add :name, :string
      add :from, :string
      add :from_name, :string
      add :to, :string
      add :to_name, :string
    end

    create index(:journey, [:slack_id, :team, :name], unique: true)
    
  end
end
