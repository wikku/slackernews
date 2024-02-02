defmodule Slackernews.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :string
      add :author_id, references(:users, on_delete: :delete_all)
      add :post_id, references(:posts, on_delete: :delete_all)
      add :parent_id, references(:comments, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:comments, [:author_id])
    create index(:comments, [:post_id])
    create index(:comments, [:parent_id])
  end
end
