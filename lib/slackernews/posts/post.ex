defmodule Slackernews.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string
    field :url, :string
    belongs_to :author, Slackernews.Accounts.User
    has_many :votes, Slackernews.Posts.PostVote
    field :score, :integer, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :url])
    |> validate_required([:title, :body, :url])
  end
end
