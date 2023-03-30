defmodule Risk4Web.StatusController do
  use Risk4Web, :controller

  alias Risk4.Shared
  alias Risk4.Shared.Status

  def index(conn, _params) do
    statuses = Shared.list_statuses()
    render(conn, :index, statuses: statuses)
  end

  def new(conn, _params) do
    changeset = Shared.change_status(%Status{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"status" => status_params}) do
    IO.inspect(status_params)
    case Shared.create_status(status_params) do
      {:ok, status} ->
        conn
        |> put_flash(:info, "Status created successfully.")
        |> redirect(to: ~p"/statuses/#{status}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    status = Shared.get_status!(id)
    render(conn, :show, status: status)
  end

  def edit(conn, %{"id" => id}) do
    status = Shared.get_status!(id)
    changeset = Shared.change_status(status)
    render(conn, :edit, status: status, changeset: changeset)
  end

  def update(conn, %{"id" => id, "status" => status_params}) do
    status = Shared.get_status!(id)

    case Shared.update_status(status, status_params) do
      {:ok, status} ->
        conn
        |> put_flash(:info, "Status updated successfully.")
        |> redirect(to: ~p"/statuses/#{status}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, status: status, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    status = Shared.get_status!(id)
    {:ok, _status} = Shared.delete_status(status)

    conn
    |> put_flash(:info, "Status deleted successfully.")
    |> redirect(to: ~p"/statuses")
  end
end
