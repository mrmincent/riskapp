defmodule Risk4.Repo.Migrations.CreateThreats do
  use Ecto.Migration

  def change do
    create table(:threats) do
      add :name, :string
      add :description, :string
      add :status_id, references(:statuses, on_delete: :nothing)

      timestamps()
    end

    create index(:threats, [:status_id])
  end
end
