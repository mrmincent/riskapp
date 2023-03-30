defmodule Risk4Web.UserController do
  use Risk4Web, :controller

  alias Risk4.Shared
  alias Risk4.Repo
  alias Risk4.Shared.User

  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    users = Shared.list_users()
    render(conn, :index, users: users)
  end

  def new(conn, _params) do
    changeset = Shared.change_user(%User{})
    statuses = Risk4.Repo.all(Risk4.Shared.Status)
    users = Risk4.Repo.all(Risk4.Shared.User)
    render(conn, :new, changeset: changeset, statuses: statuses, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    IO.puts("In create_user_controller")
    case Shared.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Shared.get_user!(id)
    render(conn, :show, user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Shared.get_user!(id)
    changeset = Shared.change_user(user)
    users = Repo.all(Risk4.Shared.User)
    render(conn, :edit, user: user, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Shared.get_user!(id)

    case Shared.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Shared.get_user!(id)
    {:ok, _user} = Shared.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end
end
