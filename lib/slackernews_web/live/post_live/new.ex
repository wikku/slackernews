defmodule SlackernewsWeb.PostLive.New do
  use SlackernewsWeb, :live_view

  alias Slackernews.Posts
  alias Slackernews.Posts.Post

  @impl true
  def render(assigns) do
    ~H"""
    <.live_component
      module={SlackernewsWeb.PostLive.FormComponent}
      current_user={@current_user}
      id='new'
      title="New post"
      action={:new}
      post={%Post{author_id: @current_user.id}}
    />
    """
  end

end
