defmodule Slackernews.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string
      add :author_id, references(:users, on_delete: :delete_all)
      add :parent_post_id, references(:posts, on_delete: :delete_all)
      add :parent_comment_id, references(:comments, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:author_id])
    create index(:comments, [:parent_post_id])
    create index(:comments, [:parent_comment_id])
  end
end
