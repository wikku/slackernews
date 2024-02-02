defmodule SlackernewsWeb.CommentLive.Show do
  use Phoenix.Component
  import SlackernewsWeb.CoreComponents


  @impl true
  def comment(assigns) do
    ~H"""
    <div class="m-10">
      <hr/>
      <div><.timestamp obj={@comment}/></div>
      <div> <%= @comment.body %> </div>
      <ul class="ml-8">
        <li>
          <details>
            <summary>Reply:</summary>
            <.live_component
              module={SlackernewsWeb.CommentLive.FormComponent}
              current_user={@current_user}
              id={"reply-to-#{@comment.id}"}
              action={:new}
              post_id={@post.id}
              comment={%Slackernews.Comments.Comment{author: @current_user, parent_post_id: @post.id, parent_comment_id: @comment.id}}
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
