defmodule Slackernews.Repo.Migrations.CreatePostVotes do
  use Ecto.Migration

  def change do
    create table(:post_votes) do
      add :post_id, references(:posts)
      add :author_id, references(:users)
      add :type, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:post_votes, [:post_id, :author_id])
  end
end
