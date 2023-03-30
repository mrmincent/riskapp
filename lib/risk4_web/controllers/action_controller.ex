defmodule Risk4Web.ActionController do
  use Risk4Web, :controller

  alias Risk4.Assessment
  alias Risk4.Repo
  alias Risk4.Assessment.Action

  def index(conn, _params) do
    actions = Assessment.list_actions()
    render(conn, :index, actions: actions)
  end

  def new(conn, _params) do
    changeset = Assessment.change_action(%Action{})
    statuses = Risk4.Repo.all(Risk4.Shared.Status) # Fetch the list of statuses
    categories = Risk4.Repo.all(Risk4.Shared.Category) # Fetch the list of statuses
    users = Risk4.Repo.all(Risk4.Shared.User) # Fetch the list of statuses
    render(conn, :new, changeset: changeset, statuses: statuses, categories: categories, users: users)
  end

  def create(conn, %{"action" => action_params}) do
    case Assessment.create_action(action_params) do
      {:ok, action} ->
        conn
        |> put_flash(:info, "Action created successfully.")
        |> redirect(to: ~p"/actions/#{action}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    action = Assessment.get_action!(id)
    render(conn, :show, action: action)
  end

  def edit(conn, %{"id" => id}) do
    action = Assessment.get_action!(id)
    changeset = Assessment.change_action(action)
    statuses = Risk4.Repo.all(Risk4.Shared.Status) # Fetch the list of statuses
    categories = Risk4.Repo.all(Risk4.Shared.Category) # Fetch the list of statuses
    users = Risk4.Repo.all(Risk4.Shared.User) # Fetch the list of statuses
    render(conn, :edit, action: action, changeset: changeset, statuses: statuses, categories: categories, users: users)
  end

  def update(conn, %{"id" => id, "action" => action_params}) do
    action = Assessment.get_action!(id)

    case Assessment.update_action(action, action_params) do
      {:ok, action} ->
        conn
        |> put_flash(:info, "Action updated successfully.")
        |> redirect(to: ~p"/actions/#{action}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, action: action, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    action = Assessment.get_action!(id)
    {:ok, _action} = Assessment.delete_action(action)

    conn
    |> put_flash(:info, "Action deleted successfully.")
    |> redirect(to: ~p"/actions")
  end
end
