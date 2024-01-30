defmodule SlackernewsWeb.PostLive.VoteComponent do
  use SlackernewsWeb, :live_component

  alias Slackernews.Posts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.button phx-click="up" phx-target="{@myself}">
        <%= if @vote == 1 do %>▲<% else %>△<% end %>
      </.button>
      <.button phx-click="down" phx-target="{@myself}">
        <%= if @vote == -1 do %>▼<% else %>▽<% end %>
      </.button>
      <span> <%= @score %> </span>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    score = Posts.get_post!(assigns.id).score
    vote = Posts.users_vote(assigns.user_id, assigns.id)
    {:ok, assign(socket, score: score, vote: vote)}
  end

end
