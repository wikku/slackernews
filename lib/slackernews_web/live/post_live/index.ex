defmodule SlackernewsWeb.PostLive.Index do
  use SlackernewsWeb, :live_view

  alias Slackernews.Posts
  alias Slackernews.Posts.Post

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Posts.subscribe()
    {:ok, stream(socket, :posts, Posts.list_posts(socket.assigns.live_action))}
  end


#  @impl true
#  def handle_info({SlackernewsWeb.PostLive.FormComponent, {:saved, post}}, socket) do
#    {:noreply, stream_insert(socket, :posts, post)}
#  end

  @impl true
  def handle_info({:post_created, post}, socket) do
    {:noreply, stream_insert(socket, :posts, post, at: 0)}
  end

  @impl true
  def handle_info({:post_updated, post}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  @impl true
  def handle_info({:post_deleted, post}, socket) do
    {:noreply, stream_delete(socket, :posts, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get_post!(id)
    if !Posts.can_edit(socket.assigns.current_user, post) do
      raise Slackernews.UnauthorizedError, "cannot edit this post"
    end
    {:ok, _} = Posts.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end
