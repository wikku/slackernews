defmodule SlackernewsWeb.CommentLive.Show do
  use Phoenix.Component
  import SlackernewsWeb.CoreComponents


  @impl true
  def comment(assigns) do
    ~H"""
    <div>
      <div class="m-4">
        <div class="text-zinc-700 text-sm">
          <span><%= @comment.author.email %></span>
          | <.timestamp obj={@comment}/>
          <.link :if={@comment.parent_id} navigate={"/posts/#{@post.id}/#{@comment.parent_id}"}>| parent</.link>
        </div>
        <div class="mb-0.5">
          <%= @comment.body %>
        </div>
        <div :if={@current_user} class="text-sm">
          <details>
            <summary class="text-zinc-700 text-xs list-none cursor-pointer">reply</summary>
            <.live_component
              module={SlackernewsWeb.CommentLive.FormComponent}
              current_user={@current_user}
              id={"reply-to-#{@comment.id}"}
              action={:new}
              post_id={@post.id}
              comment={%Slackernews.Comments.Comment{author_id: @current_user.id, post_id: @post.id, parent_id: @comment.id}}
            />
          </details>
        </div>
      </div>
      <ul class="ml-8">
        <%= if is_list(@comment.child_comments) do %>
          <%= for child <- @comment.child_comments || [] do %>
            <li>
              <.comment comment={child} current_user={@current_user} post={@post}/>
            </li>
          <% end %>
        <% end %>
        <%= if @comment.child_comments == :some do %>
          <.link navigate={"/posts/#{@post.id}/#{@comment.id}"}>more replies...</.link>
        <% end %>
      </ul>
    </div>
    """
  end

end
