defmodule Dragonhoard.RequestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dragonhoard.Requests` context.
  """

  @doc """
  Generate a request.
  """
  def request_fixture(attrs \\ %{}) do
    {:ok, request} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Dragonhoard.Requests.create_request()

    request
  end
end
