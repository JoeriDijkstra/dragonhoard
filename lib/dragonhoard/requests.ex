defmodule Dragonhoard.Requests do
  @moduledoc """
  The Requests context.
  """

  import Ecto.Query, warn: false

  alias Dragonhoard.Inventory.Item
  alias Ecto.Multi
  alias Dragonhoard.Accounts.User
  alias Dragonhoard.Repo
  alias Dragonhoard.Requests.Request

  def list_requests(query \\ Request) do
    query
    |> Repo.all()
    |> Repo.preload([:user, item: [:holder]])
  end

  def outgoing_requests(%User{id: user_id}) do
    user_id
    |> Request.outgoing_query()
    |> list_requests()
  end

  def outgoing_requests_count(%User{id: user_id}) do
    user_id
    |> Request.outgoing_query()
    |> Request.only_open_query()
    |> Repo.aggregate(:count)
  end

  def incoming_requests_count(%User{id: user_id}) do
    user_id
    |> Request.incoming_query()
    |> Repo.aggregate(:count)
  end

  def incoming_requests(%User{id: user_id}) do
    user_id
    |> Request.incoming_query()
    |> list_requests()
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

  def approve_request(id) do
    Request
    |> Repo.get(id)
    |> Repo.preload(:item)
    |> case do
      nil ->
        {:error, :not_found_error}

      %Request{item: item} = request ->
        Multi.new()
        |> Multi.update(:update_request, Request.approve_changeset(request, true))
        |> Multi.update(:update_item, Item.changeset(item, %{holder_id: request.user_id}))
        |> Repo.transaction()
    end
  end

  def deny_request(id) do
    case Repo.get(Request, id) do
      nil ->
        {:error, :not_found_error}

      %Request{} = request ->
        Multi.new()
        |> Multi.update(:update_request, Request.approve_changeset(request, false))
        |> Repo.transaction()
    end
  end

  def delete_request(%Request{} = request) do
    Repo.delete(request)
  end

  def change_request(%Request{} = request, attrs \\ %{}) do
    Request.changeset(request, attrs)
  end
end
