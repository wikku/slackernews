defmodule Slackernews.Repo.Migrations.CreateCommentVotes do
  use Ecto.Migration

  def change do
    create table(:comment_votes) do
      add :comment_id, references(:comments, on_delete: :delete_all)
      add :voter_id, references(:users, on_delete: :delete_all)
      add :type, :integer, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:comment_votes, [:comment_id, :voter_id])
  end
end
