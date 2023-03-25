defmodule Risk4Web.ItemController do
  use Risk4Web, :controller

  alias Risk4.Asset
  alias Risk4.Asset.Item

  def index(conn, _params) do
    items = Asset.list_items()
    render(conn, :index, items: items)
  end

  def new(conn, _params) do
    changeset = Asset.change_item(%Item{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"item" => item_params}) do
    case Asset.create_item(item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item created successfully.")
        |> redirect(to: ~p"/items/#{item}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    item = Asset.get_item!(id)
    render(conn, :show, item: item)
  end

  def edit(conn, %{"id" => id}) do
    item = Asset.get_item!(id)
    changeset = Asset.change_item(item)
    render(conn, :edit, item: item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item" => item_params}) do
    item = Asset.get_item!(id)

    case Asset.update_item(item, item_params) do
      {:ok, item} ->
        conn
        |> put_flash(:info, "Item updated successfully.")
        |> redirect(to: ~p"/items/#{item}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, item: item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    item = Asset.get_item!(id)
    {:ok, _item} = Asset.delete_item(item)

    conn
    |> put_flash(:info, "Item deleted successfully.")
    |> redirect(to: ~p"/items")
  end
end
