defmodule Risk4.Asset do
  @moduledoc """
  The Asset context.
  """

  import Ecto.Query, warn: false
  alias Risk4.Repo

  alias Risk4.Asset.Asset_Type

  @doc """
  Returns the list of asset_types.

  ## Examples

      iex> list_asset_types()
      [%Asset_Type{}, ...]

  """
  def list_asset_types do
    Repo.all(Asset_Type)
  end

  @doc """
  Gets a single asset__type.

  Raises `Ecto.NoResultsError` if the Asset  type does not exist.

  ## Examples

      iex> get_asset__type!(123)
      %Asset_Type{}

      iex> get_asset__type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_asset__type!(id), do: Repo.get!(Asset_Type, id)

  @doc """
  Creates a asset__type.

  ## Examples

      iex> create_asset__type(%{field: value})
      {:ok, %Asset_Type{}}

      iex> create_asset__type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_asset__type(attrs \\ %{}) do
    %Asset_Type{}
    |> Asset_Type.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a asset__type.

  ## Examples

      iex> update_asset__type(asset__type, %{field: new_value})
      {:ok, %Asset_Type{}}

      iex> update_asset__type(asset__type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_asset__type(%Asset_Type{} = asset__type, attrs) do
    asset__type
    |> Asset_Type.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a asset__type.

  ## Examples

      iex> delete_asset__type(asset__type)
      {:ok, %Asset_Type{}}

      iex> delete_asset__type(asset__type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_asset__type(%Asset_Type{} = asset__type) do
    Repo.delete(asset__type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking asset__type changes.

  ## Examples

      iex> change_asset__type(asset__type)
      %Ecto.Changeset{data: %Asset_Type{}}

  """
  def change_asset__type(%Asset_Type{} = asset__type, attrs \\ %{}) do
    Asset_Type.changeset(asset__type, attrs)
  end

  alias Risk4.Asset.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end
end
