defmodule DragonhoardWeb.RequestLive.Index do
  use DragonhoardWeb, :live_view

  alias Dragonhoard.Requests

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :requests, Requests.list_requests())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Listing Requests")
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    request = Requests.get_request!(id)
    {:ok, _} = Requests.delete_request(request)

    {:noreply, stream_delete(socket, :requests, request)}
  end
end
