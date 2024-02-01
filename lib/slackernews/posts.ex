defmodule Slackernews.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Slackernews.Repo

  alias Slackernews.Posts.Post
  alias Slackernews.Posts.PostVote

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
#   Repo.get!(Post, id)
#   |> Repo.preload(:author)
    Repo.one! from p in Post,
                where: p.id == type(^id, :integer),
                left_join: v in assoc(p, :votes),
                group_by: p.id,
                preload: :author,
                select: %Post{p | score: coalesce(sum(v.type), 0)}
  end

  @doc """
  Creates a post.
  """
  def create_post(author_id, attrs \\ %{}) do
    %Post{author_id: author_id}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:post_created)
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
    |> broadcast(:post_updates)
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @doc """
    Returns a boolean indicating authorization to edit post.
  """
  def can_edit(user, %Post{} = post) do
    user_id = user && Map.get(user, :id)
    user_id != nil &&
    user_id == post.author_id
  end

  @doc """
    Returns the vote direction of a user on a post.
  """
  def users_vote(nil, _post_id), do: 0
  def users_vote(user_id, post_id) do
    case Repo.get_by(PostVote, [voter_id: user_id, post_id: post_id]) do
      %PostVote{type: type} -> type
      nil -> 0
    end
  end

  def cast_vote(voter_id, post_id, 0) do
    Repo.delete_all(PostVote |> where(voter_id: ^voter_id, post_id: ^post_id))
  end
  def cast_vote(voter_id, post_id, vote) do
    Repo.insert!(%PostVote{voter_id: voter_id, post_id: post_id, type: vote},
                 on_conflict: {:replace, [:type]},
                 conflict_target: [:post_id, :voter_id])
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Slackernews.PubSub, "posts")
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(Slackernews.PubSub, "posts", {event, post})
    {:ok, post}
  end

end
