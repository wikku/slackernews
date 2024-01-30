defmodule Slackernews.Posts.PostVote do
  use Ecto.Schema

  schema "post_votes" do
    belongs_to :post, Slackernews.Posts.Post
    belongs_to :author, Slackernews.Accounts.User
    field :type, Ecto.Enum, values: [upvote: 1, downvote: -1], null: false

    timestamps(type: :utc_datetime)
  end
end
