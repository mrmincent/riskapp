defmodule Risk4Web.CategoryController do
  use Risk4Web, :controller

  alias Risk4.Shared
  alias Risk4.Repo
  alias Risk4.Shared.Category

  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    categories = Category
    |> Repo.all()
    |> Repo.preload(:status)
    render(conn, :index, categories: categories)
  end

  def new(conn, _params) do
    changeset = Shared.change_category(%Category{})
    statuses = Risk4.Repo.all(Risk4.Shared.Status) # Fetch the list of statuses
    categories = Category
    |> Repo.all()
    |> Repo.preload(:status)
    render(conn, :new, changeset: changeset, statuses: statuses, categories: categories)
  end

  def create(conn, %{"category" => category_params}) do
    IO.puts("in create_category_controller")
    IO.inspect(category_params)
    categories = Category
    |> Repo.all()
    |> Repo.preload(:status)

    case Shared.create_category(category_params) do

      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: ~p"/categories/#{category}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Shared.get_category!(id)
    render(conn, :show, category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = Shared.get_category!(id)
    changeset = Shared.change_category(category)
    statuses = Risk4.Repo.all(Risk4.Shared.Status) # Fetch the list of statuses
    render(conn, :edit, category: category, changeset: changeset, statuses: statuses)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Shared.get_category!(id)

    case Shared.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: ~p"/categories/#{category}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Shared.get_category!(id)
    {:ok, _category} = Shared.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: ~p"/categories")
  end
end
