defmodule Risk4.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :description, :string
      add :status_id, references(:statuses, on_delete: :nothing)

      timestamps()
    end

    create index(:categories, [:status_id])
  end
end
