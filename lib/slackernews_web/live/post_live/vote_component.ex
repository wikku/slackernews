defmodule SlackernewsWeb.PostLive.VoteComponent do
  use SlackernewsWeb, :live_component

  alias Slackernews.Posts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.button phx-click="up" phx-target={@myself}>
        <%= if @vote == 1 do %>▲<% else %>△<% end %>
      </.button>
      <.button phx-click="down" phx-target={@myself}>
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
    {:ok, assign(socket, score: score, vote: vote, id: assigns.id, user_id: assigns.user_id)}
  end

  @impl true
  def handle_event("up", _, socket), do: handle_vote(1, socket)

  @impl true
  def handle_event("down", _, socket), do: handle_vote(-1, socket)

  defp handle_vote(clicked_vote, socket) do
    if !socket.assigns.user_id do
      raise Slackernews.UnauthorizedError, "log in to vote"
    end
    vote = socket.assigns.vote
    new_vote = if vote == clicked_vote do 0 else clicked_vote end
    new_score = socket.assigns.score - vote + new_vote
    Posts.cast_vote(socket.assigns.user_id, socket.assigns.id, new_vote)
    {:noreply, assign(socket, score: new_score, vote: new_vote)}
  end

end
