defmodule Risk4Web.ControlController do
  use Risk4Web, :controller

  alias Risk4.Assessment
  alias Risk4.Assessment.Control

  def index(conn, _params) do
    controls = Assessment.list_controls()
    render(conn, :index, controls: controls)
  end

  def new(conn, _params) do
    changeset = Assessment.change_control(%Control{})
    statuses = Risk4.Repo.all(Risk4.Shared.Status) # Fetch the list of statuses
    users = Risk4.Repo.all(Risk4.Shared.User) # Fetch the list of users
    render(conn, :new, changeset: changeset, statuses: statuses, users: users)
  end

  def create(conn, %{"control" => control_params}) do
    case Assessment.create_control(control_params) do
      {:ok, control} ->
        conn
        |> put_flash(:info, "Control created successfully.")
        |> redirect(to: ~p"/controls/#{control}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    control = Assessment.get_control!(id)
    render(conn, :show, control: control)
  end

  def edit(conn, %{"id" => id}) do
    control = Assessment.get_control!(id)
    changeset = Assessment.change_control(control)
    statuses = Risk4.Repo.all(Risk4.Shared.Status) # Fetch the list of statuses
    users = Risk4.Repo.all(Risk4.Shared.User) # Fetch the list of users

    render(conn, :edit, control: control, changeset: changeset, statuses: statuses, users: users)
  end

  def update(conn, %{"id" => id, "control" => control_params}) do
    control = Assessment.get_control!(id)

    case Assessment.update_control(control, control_params) do
      {:ok, control} ->
        conn
        |> put_flash(:info, "Control updated successfully.")
        |> redirect(to: ~p"/controls/#{control}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, control: control, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    control = Assessment.get_control!(id)
    {:ok, _control} = Assessment.delete_control(control)

    conn
    |> put_flash(:info, "Control deleted successfully.")
    |> redirect(to: ~p"/controls")
  end
end
