defmodule Slackernews.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    belongs_to :author, Slackernews.Accounts.User
    belongs_to :parent_post, Slackernews.Posts.Post
    belongs_to :parent_comment, Slackernews.Comments.Comment
    has_many :child_comments, Slackernews.Comments.Comment
    field :score, :integer, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
