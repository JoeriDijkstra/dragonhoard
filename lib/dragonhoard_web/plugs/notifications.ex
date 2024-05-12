defmodule DragonhoardWeb.Plugs.Notifications do
  import Plug.Conn

  alias Dragonhoard.Requests

  def init(default), do: default

  def call(%Plug.Conn{assigns: %{current_user: user}} = conn, _default) do
    outgoing = Requests.outgoing_requests_count(user)

    assign(conn, :notifications, %{outgoing: outgoing})
  end
end
