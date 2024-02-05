defmodule SlackernewsWeb.PostLive.ShowComponent do
  use SlackernewsWeb, :live_component

  alias Slackernews.Posts

  @impl true
  def render(assigns) do
    ~H"""
      <div class="flex items-center">
        <.live_component
          module={SlackernewsWeb.PostLive.VoteComponent}
          user_id={@current_user && @current_user.id}
          id={@post.id}
        />
        <div>
          <a href={@post.url} class="font-medium"><%= @post.title %></a>
          <span class="text-zinc-500 text-xs">(<%= URI.parse(@post.url).host %>)</span>
          <div class="text-zinc-700 text-sm">
            <span><%= @post.author.username %></span>
            | <.timestamp obj={@post}/>
            | <.link navigate={"/posts/#{@post.id}"}><%= @post.comment_count %> comments</.link>
            <%= if Posts.can_edit(@current_user, @post) do %>
            | <.link :if={Posts.can_edit(@current_user, @post)} patch={~p"/posts/#{@post}/show/edit"} phx-click={JS.push_focus()}>
                edit
              </.link>
            <% end %>
          </div>
        </div>
      </div>
    """
  end

end
