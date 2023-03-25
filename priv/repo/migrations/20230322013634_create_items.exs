defmodule Risk4.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :confidentiality, :integer
      add :integrity, :integer
      add :availablity, :integer
      add :value, :integer
      add :justification, :string
      add :status_id, references(:statuses, on_delete: :nothing)
      add :asset_type_id, references(:asset_types, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:items, [:status_id])
    create index(:items, [:asset_type_id])
    create index(:items, [:category_id])
  end
end
