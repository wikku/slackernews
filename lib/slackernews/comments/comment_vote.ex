defmodule Slackernews.Comments.CommentVote do
  use Ecto.Schema

  schema "comment_votes" do
    belongs_to :comment, Slackernews.Comments.Comment
    belongs_to :voter, Slackernews.Accounts.User
    field :type, :integer

    timestamps(type: :utc_datetime)
  end
end
