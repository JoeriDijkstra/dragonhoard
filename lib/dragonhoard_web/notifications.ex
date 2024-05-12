defmodule DragonhoardWeb.Notifications do
  use DragonhoardWeb, :verified_routes

  alias Dragonhoard.Requests

  def on_mount(:put_notifications, _params, _session, %{assigns: %{current_user: user}} = socket) do
    outgoing = Requests.outgoing_requests_count(user)
    incoming = Requests.incoming_requests_count(user)

    {:cont,
     Phoenix.Component.assign(socket, :notifications, %{
       outgoing: outgoing,
       incoming: incoming
     })}
  end

  def on_mount(:put_notifications, _, _, socket) do
    {:cont,
     Phoenix.Component.assign(socket, :notifications, %{
       outgoing: 0,
       incoming: 0
     })}
  end
end
