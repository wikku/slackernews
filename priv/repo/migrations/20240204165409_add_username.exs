defmodule Slackernews.Repo.Migrations.AddUsername do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :citext, null: false
      modify :email, :citext, null: true
    end

    create unique_index(:users, [:username])
  end
end
