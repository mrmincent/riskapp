defmodule Risk4Web.Asset_TypeController do
  use Risk4Web, :controller

  alias Risk4.Asset
  alias Risk4.Asset.Asset_Type

  def index(conn, _params) do
    asset_types = Asset.list_asset_types()
    render(conn, :index, asset_types: asset_types)
  end

  def new(conn, _params) do
    changeset = Asset.change_asset__type(%Asset_Type{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"asset__type" => asset__type_params}) do
    case Asset.create_asset__type(asset__type_params) do
      {:ok, asset__type} ->
        conn
        |> put_flash(:info, "Asset  type created successfully.")
        |> redirect(to: ~p"/asset_types/#{asset__type}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    asset__type = Asset.get_asset__type!(id)
    render(conn, :show, asset__type: asset__type)
  end

  def edit(conn, %{"id" => id}) do
    asset__type = Asset.get_asset__type!(id)
    changeset = Asset.change_asset__type(asset__type)
    render(conn, :edit, asset__type: asset__type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "asset__type" => asset__type_params}) do
    asset__type = Asset.get_asset__type!(id)

    case Asset.update_asset__type(asset__type, asset__type_params) do
      {:ok, asset__type} ->
        conn
        |> put_flash(:info, "Asset  type updated successfully.")
        |> redirect(to: ~p"/asset_types/#{asset__type}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, asset__type: asset__type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    asset__type = Asset.get_asset__type!(id)
    {:ok, _asset__type} = Asset.delete_asset__type(asset__type)

    conn
    |> put_flash(:info, "Asset  type deleted successfully.")
    |> redirect(to: ~p"/asset_types")
  end
end
