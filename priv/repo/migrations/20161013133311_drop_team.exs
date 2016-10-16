defmodule Trainbot.Repo.Migrations.CreateJourney do
  use Ecto.Migration

  def change do
    drop index(:journey, [:slack_id, :team, :name], unique: true)
    alter table(:journey) do
      remove :team
    end

    create index(:journey, [:slack_id, :name], unique: true)
  end
end
