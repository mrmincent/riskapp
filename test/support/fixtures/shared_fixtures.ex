defmodule Risk4.SharedFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Risk4.Shared` context.
  """

  @doc """
  Generate a status.
  """
  def status_fixture(attrs \\ %{}) do
    {:ok, status} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Risk4.Shared.create_status()

    status
  end

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Risk4.Shared.create_category()

    category
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        avatar: "some avatar",
        email: "some email",
        fname: "some fname",
        level: 42,
        lname: "some lname",
        phone: "some phone"
      })
      |> Risk4.Shared.create_user()

    user
  end
end
