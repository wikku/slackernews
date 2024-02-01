defmodule Slackernews.Repo.Migrations.CreatePostVotes do
  use Ecto.Migration

  def change do
    create table(:post_votes) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :voter_id, references(:users, on_delete: :delete_all)
      add :type, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:post_votes, [:post_id, :voter_id])
  end
end
