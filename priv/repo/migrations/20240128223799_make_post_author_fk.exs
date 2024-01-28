defmodule Slackernews.Repo.Migrations.MakePostAuthorFK do
  use Ecto.Migration

  def change do
    rename table(:posts), :author, to: :author_id
    alter table(:posts) do
      modify :author_id, references(:users), from: :id
    end
  end

end
