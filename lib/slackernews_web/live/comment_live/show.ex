defmodule SlackernewsWeb.CommentLive.Show do
  use Phoenix.Component
  import SlackernewsWeb.CoreComponents


  def comment(assigns) do
    ~H"""
    <div>
      <div class="flex my-4">
        <.live_component
          module={SlackernewsWeb.CommentLive.VoteComponent}
          user_id={@current_user && @current_user.id}
          id={@comment.id}
        />
        <div>
          <div class="text-zinc-700 text-sm">
            <span><%= @comment.author.username %></span>
            | <.timestamp obj={@comment}/>
            <.link :if={@comment.parent_id} navigate={"/posts/#{@post.id}/#{@comment.parent_id}"}>| parent</.link>
          </div>
          <div class="mb-0.5">
            <%= @comment.body %>
          </div>
          <div :if={@current_user && @current_user.id == @comment.author_id}>
            <details>
              <summary class="text-zinc-700 text-xs list-none cursor-pointer">edit</summary>
              <.live_component
                module={SlackernewsWeb.CommentLive.FormComponent}
                current_user={@current_user}
                id={"edit-#{@comment.id}"}
                action={:edit}
                post_id={@post.id}
                comment={@comment}
              />
            </details>

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
      </div>
      <ul class="ml-8">
        <%= if is_list(@comment.child_comments) do %>
          <%= for child <- @comment.child_comments || [] do %>
            <li>
              <.comment comment={child} current_user={@current_user} post={@post}/>
            </li>
          <% end %>
        <% end %>
        <div :if={@comment.child_comments == :some} class="mt-4" %>
          <.link navigate={"/posts/#{@post.id}/#{@comment.id}"}>more replies...</.link>
        </div>
      </ul>
    </div>
    """
  end

end
