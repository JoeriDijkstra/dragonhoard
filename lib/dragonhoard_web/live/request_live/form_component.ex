defmodule DragonhoardWeb.RequestLive.FormComponent do
  use DragonhoardWeb, :live_component

  alias Dragonhoard.Requests

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage request records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="request-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:title]}
          type="text"
          label="Title"
          value={"Requesting #{@item.name} from #{@item.holder.email}"}
        />
        <.input field={@form[:amount]} type="number" max={@item.amount} label="Amount" value="1" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Request</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{request: request} = assigns, socket) do
    changeset = Requests.change_request(request)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"request" => request_params}, socket) do
    changeset =
      socket.assigns.request
      |> Requests.change_request(request_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"request" => request_params}, socket) do
    save_request(socket, socket.assigns.action, request_params)
  end

  defp save_request(socket, :edit, request_params) do
    case Requests.update_request(socket.assigns.request, request_params) do
      {:ok, request} ->
        notify_parent({:saved, request})

        {:noreply,
         socket
         |> put_flash(:info, "Request updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_request(
         %{assigns: %{current_user: %{id: user_id}, item: %{id: item_id}}} = socket,
         :request,
         request_params
       ) do
    request_params = Map.merge(request_params, %{"user_id" => user_id, "item_id" => item_id})

    case Requests.create_request(request_params) do
      {:ok, request} ->
        notify_parent({:saved, request})

        {:noreply,
         socket
         |> put_flash(:info, "Item successfully requested")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
