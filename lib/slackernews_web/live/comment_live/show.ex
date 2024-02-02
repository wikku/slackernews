defmodule SlackernewsWeb.CommentLive.Show do
  use Phoenix.Component
  import SlackernewsWeb.CoreComponents


  @impl true
  def comment(assigns) do
    ~H"""
    <div>
      <div><.timestamp obj={@comment}/></div>
      <div> <%= @comment.body %> </div>
      <%= if is_list(@comment.child_comments) do %>
      <ul>
      <%= for child <- {@comment.child_comments || []} do %>
        <li>
        <.comment comment={child}/>
        </li>
      <% end %>
      </ul>
      <% end %>
    </div>
    """
  end

end
