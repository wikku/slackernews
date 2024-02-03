defmodule SlackernewsWeb.CommentLive.Show do
  use Phoenix.Component
  import SlackernewsWeb.CoreComponents


  @impl true
  def comment(assigns) do
    ~H"""
    <div class="m-10">
      <hr/>
      <div>
        <.timestamp obj={@comment}/>
        <.link :if={@comment.parent_id} href={"/posts/#{@post.id}/#{@comment.parent_id}"}>Parent</.link>
      </div>
      <div> <%= @comment.body %> </div>
      <ul class="ml-8">
        <li :if={@current_user}>
          <details>
            <summary>Reply:</summary>
            <.live_component
              module={SlackernewsWeb.CommentLive.FormComponent}
              current_user={@current_user}
              id={"reply-to-#{@comment.id}"}
              action={:new}
              post_id={@post.id}
              comment={%Slackernews.Comments.Comment{author_id: @current_user.id, post_id: @post.id, parent_id: @comment.id}}
            />
          </details>
        </li>
        <%= if is_list(@comment.child_comments) do %>
          <%= for child <- @comment.child_comments || [] do %>
            <li>
              <.comment comment={child} current_user={@current_user} post={@post}/>
            </li>
          <% end %>
        <% end %>
      </ul>
    </div>
    """
  end

end
