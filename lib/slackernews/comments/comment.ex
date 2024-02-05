defmodule Slackernews.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    belongs_to :author, Slackernews.Accounts.User
    belongs_to :post, Slackernews.Posts.Post
    belongs_to :parent, Slackernews.Comments.Comment
    has_many :child_comments, Slackernews.Comments.Comment, foreign_key: :parent_id
    has_many :votes, Slackernews.Comments.CommentVote
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
