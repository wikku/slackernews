defmodule SlackernewsWeb.PostLive.Show do
  use SlackernewsWeb, :live_view

  alias Slackernews.Posts
  alias Slackernews.Comments

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, Posts.get_post!(id))
     |> assign(:comments, Comments.list_post_comments(id))}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end
