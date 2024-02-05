defmodule Slackernews.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias Slackernews.Repo

  alias Slackernews.Comments.Comment
  alias Slackernews.Comments.CommentVote
  alias Slackernews.Accounts.User

  @comments_with_score (
    from c in Comment,
    left_join: v in assoc(c, :votes),
    left_join: r in assoc(c, :child_comments),
    group_by: c.id,
    preload: :author,
    select: %Comment{c | score: coalesce(sum(v.type), 0)}
  )

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
  end

  @doc """
  Returns the list of comments under a post.
  """
  def list_post_comments(post_id) do
    Repo.all(from c in Comment, where: c.post_id == ^post_id and is_nil(c.parent_id))
  end

  @doc """
  """
  def load_child_comments(%Comment{} = c, 0) do
    Repo.preload(c, [:author, :child_comments])
    |> Map.update!(:child_comments, fn
       [] -> []
       [_|_] -> [:some]
    end)
  end
  def load_child_comments(%Comment{} = c, depth) when depth > 0 do
    c
    |> Repo.preload([:child_comments, :author])
    |> Map.update!(:child_comments, &Enum.map(&1, fn c -> load_child_comments(c, depth-1) end))
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id) do
    Repo.one! from p in Comment,
                where: p.id == type(^id, :integer),
                left_join: v in assoc(p, :votes),
                group_by: p.id,
                preload: [:author, :child_comments],
                select: %Comment{p | score: coalesce(sum(v.type), 0)}
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(author_id, post_id, parent_id, attrs \\ %{}) do
    %Comment{author_id: author_id, post_id: post_id, parent_id: parent_id}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end

  @doc """
    Returns a boolean indicating authorization to edit post.
  """
  def can_edit(nil, _comment), do: false
  def can_edit(%User{id: id}, %Comment{} = comment) do
    id && id == comment.author_id
  end

  @doc """
    Returns the vote direction of a user on a comment.
  """
  def users_vote(nil, _comment_id), do: 0
  def users_vote(user_id, comment_id) do
    case Repo.get_by(CommentVote, [voter_id: user_id, comment_id: comment_id]) do
      %CommentVote{type: type} -> type
      nil -> 0
    end
  end

  def cast_vote(voter_id, comment_id, 0) do
    Repo.delete_all(CommentVote |> where(voter_id: ^voter_id, comment_id: ^comment_id))
  end
  def cast_vote(voter_id, comment_id, vote) do
    Repo.insert!(%CommentVote{voter_id: voter_id, comment_id: comment_id, type: vote},
                 on_conflict: {:replace, [:type]},
                 conflict_target: [:comment_id, :voter_id])
  end
end
