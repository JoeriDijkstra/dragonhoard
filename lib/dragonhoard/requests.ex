defmodule Dragonhoard.Requests do
  @moduledoc """
  The Requests context.
  """

  import Ecto.Query, warn: false
  alias Dragonhoard.Repo

  alias Dragonhoard.Requests.Request

  def list_requests do
    Repo.all(Request)
  end

  def get_request!(id), do: Repo.get!(Request, id)

  def create_request(attrs \\ %{}) do
    %Request{}
    |> Request.changeset(attrs)
    |> Repo.insert()
  end

  def update_request(%Request{} = request, attrs) do
    request
    |> Request.changeset(attrs)
    |> Repo.update()
  end

  def approve_request(%Request{} = request) do
    request
    |> Request.approve_changeset(true)
    |> Repo.update()
  end

  def delete_request(%Request{} = request) do
    Repo.delete(request)
  end

  def change_request(%Request{} = request, attrs \\ %{}) do
    Request.changeset(request, attrs)
  end
end
