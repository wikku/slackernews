defmodule Slackernews.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string
    field :url, :string
    belongs_to :author, Slackernews.Accounts.User
    has_many :votes, Slackernews.Posts.PostVote
    has_many :comments, Slackernews.Comments.Comment

    field :score, :integer, virtual: true
    field :comment_count, :integer, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :url])
    |> validate_required([:title, :url])
  end
end
