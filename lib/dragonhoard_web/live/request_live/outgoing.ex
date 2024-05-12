defmodule DragonhoardWeb.RequestLive.Outgoing do
  use DragonhoardWeb, :live_view

  alias Dragonhoard.Requests

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :requests, Requests.outgoing_requests(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Listing Outgoing Requests")
  end
end
