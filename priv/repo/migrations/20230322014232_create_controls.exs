defmodule Risk4.Repo.Migrations.CreateControls do
  use Ecto.Migration

  def change do
    create table(:controls) do
      add :name, :string
      add :description, :string
      add :status_id, references(:statuses, on_delete: :nothing)
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:controls, [:status_id])
    create index(:controls, [:owner_id])
  end
end
