defmodule Risk4.Repo.Migrations.CreateAssetTypes do
  use Ecto.Migration

  def change do
    create table(:asset_types) do
      add :name, :string
      add :description, :string
      add :status_id, references(:statuses, on_delete: :nothing)

      timestamps()
    end

    create index(:asset_types, [:status_id])
  end
end
