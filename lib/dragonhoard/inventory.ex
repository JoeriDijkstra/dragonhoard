defmodule Dragonhoard.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias Dragonhoard.Repo

  alias Dragonhoard.Inventory.Item

  def list_items do
    Repo.all(Item)
  end

  @spec get_item!(binary(), list[atom()]) :: %Item{} | nil
  def get_item!(id, preloads \\ [])

  def get_item!(id, []), do: Repo.get!(Item, id)

  def get_item!(id, preloads) do
    Item
    |> Repo.get!(id)
    |> Repo.preload(preloads)
  end

  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end
end
