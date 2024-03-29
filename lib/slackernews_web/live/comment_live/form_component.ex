defmodule SlackernewsWeb.CommentLive.FormComponent do
  use SlackernewsWeb, :live_component

  alias Slackernews.Comments

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id={@id}
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:body]} type="textarea"/>
        <:actions>
          <.button phx-disable-with="Saving...">
            <%= case @action do
            :new -> "Add Comment"
            :edit -> "Save Comment"
            end %>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = Comments.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    changeset =
      socket.assigns.comment
      |> Comments.change_comment(comment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    save_comment(socket, socket.assigns.action, comment_params)
  end

  defp save_comment(socket, :edit, comment_params) do
    if !Comments.can_edit(socket.assigns.current_user, socket.assigns.comment) do
      raise Slackernews.UnauthorizedError, "cannot edit this comment"
    end
    case Comments.update_comment(socket.assigns.comment, comment_params) do
      {:ok, comment} ->
        socket.assigns.on_update.(comment)
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_comment(socket, :new, comment_params) do
    if !socket.assigns.current_user do
      raise Slackernews.UnauthorizedError, "log in to make comment"
    end
    IO.inspect("asdf")
    comment = socket.assigns.comment
    empty = %Comments.Comment{comment | body: nil}
    case Comments.create_comment(comment.author_id, comment.post_id, comment.parent_id, comment_params) do
      {:ok, comment} ->
        comment = %Comments.Comment{comment | author: socket.assigns.current_user, child_comments: []}
        socket.assigns.on_reply.(comment)
        send_update(socket.assigns.myself, comment: empty)
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect("asdf")
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset, id: socket.assigns.id))
  end

end
