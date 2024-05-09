defmodule DragonhoardWeb.ItemLive.Index do
  use DragonhoardWeb, :live_view

  alias Dragonhoard.Inventory
  alias Dragonhoard.Inventory.Item

  @impl true
  def mount(params, _session, socket) do
    {:ok, stream(socket, :items, fetch_items(params, socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item")
    |> assign(:item, Inventory.get_item!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:item, %Item{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Items")
    |> assign(:item, nil)
  end

  @impl true
  def handle_info({DragonhoardWeb.ItemLive.FormComponent, {:saved, item}}, socket) do
    {:noreply, stream_insert(socket, :items, item)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = Inventory.get_item!(id)
    {:ok, _} = Inventory.delete_item(item)

    {:noreply, stream_delete(socket, :items, item)}
  end

  defp fetch_items(%{"filter" => "mine"}, user), do: Inventory.my_items(user)
  defp fetch_items(%{"filter" => "held"}, user), do: Inventory.held_items(user)
  defp fetch_items(_, _), do: Inventory.list_items()
end
