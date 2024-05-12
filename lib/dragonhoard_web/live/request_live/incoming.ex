defmodule DragonhoardWeb.RequestLive.Incoming do
  use DragonhoardWeb, :live_view

  alias Dragonhoard.Requests

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :requests, Requests.incoming_requests(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Listing Incoming Requests")
  end

  defp apply_action(socket, :approve, %{"id" => id}) do
    case Requests.approve_request(id) do
      {:ok, %{update_request: request}} ->
        socket
        |> put_flash(:info, "Request succesfully approved")
        |> stream_delete(:requests, request)
        |> refresh_notifications
        |> push_patch(to: ~p"/requests/incoming")

      _ ->
        socket
        |> put_flash(:error, "Something went wrong approving the request")
        |> refresh_notifications
        |> push_patch(to: ~p"/requests/incoming")
    end
  end

  defp apply_action(socket, :deny, %{"id" => id}) do
    case Requests.deny_request(id) do
      {:ok, %{update_request: request}} ->
        socket
        |> put_flash(:info, "Request succesfully denied")
        |> stream_delete(:requests, request)
        |> refresh_notifications()
        |> push_patch(to: ~p"/requests/incoming")

      _ ->
        socket
        |> put_flash(:error, "Something went wrong approving the request")
        |> refresh_notifications()
        |> push_patch(to: ~p"/requests/incoming")
    end
  end

  defp refresh_notifications(%{assigns: %{current_user: user}} = socket) do
    outgoing = Requests.outgoing_requests_count(user)
    incoming = Requests.incoming_requests_count(user)

    assign(socket, :notifications, %{
      outgoing: outgoing,
      incoming: incoming
    })
  end
end
