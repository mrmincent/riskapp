defmodule Risk4.AssetFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Risk4.Asset` context.
  """

  @doc """
  Generate a asset__type.
  """
  def asset__type_fixture(attrs \\ %{}) do
    {:ok, asset__type} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Risk4.Asset.create_asset__type()

    asset__type
  end

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        availablity: 42,
        confidentiality: 42,
        integrity: 42,
        justification: "some justification",
        name: "some name",
        value: 42
      })
      |> Risk4.Asset.create_item()

    item
  end
end
