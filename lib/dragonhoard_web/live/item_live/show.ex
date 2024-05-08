defmodule DragonhoardWeb.ItemLive.Show do
  use DragonhoardWeb, :live_view

  alias Dragonhoard.Inventory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    item = Inventory.get_item!(id, [:owner, :holder])
    changeset = Inventory.change_item(item)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign_form(changeset)
     |> assign(:item, item)}
  end

  @impl true
  def handle_event("save", %{"item" => item_params}, socket) do
    case Inventory.update_item(socket.assigns.item, item_params) do
      {:ok, _item} ->
        {:noreply, put_flash(socket, :info, "Item updated successfully")}

      {:error, %Ecto.Changeset{}} ->
        {:noreply, put_flash(socket, :error, "Error updating item")}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp page_title(:show), do: "Show Item"
  defp page_title(:edit), do: "Edit Item"
end
