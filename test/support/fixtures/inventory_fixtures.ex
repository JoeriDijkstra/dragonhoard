defmodule Dragonhoard.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dragonhoard.Inventory` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        amount: 42,
        description: "some description",
        name: "some name"
      })
      |> Dragonhoard.Inventory.create_item()

    item
  end
end
