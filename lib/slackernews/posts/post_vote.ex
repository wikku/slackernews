defmodule Slackernews.Posts.PostVote do
  use Ecto.Schema

  schema "post_votes" do
    belongs_to :post, Slackernews.Posts.Post
    belongs_to :voter, Slackernews.Accounts.User
    field :type, :integer

    timestamps(type: :utc_datetime)
  end
end
