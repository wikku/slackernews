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
        <.input field={@form[:body]} type="text" label="Body" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Comment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    comment = %Comments.Comment{id: assigns.post_id, author: assigns.current_user}
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
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

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
    case Comments.create_comment(comment.author_id, comment.parent_post_id, comment.parent_comment_id, comment_params) do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully") }

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect("asdf")
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset, id: socket.assigns.id))
  end

end
