defmodule Risk4.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions) do
      add :title, :string
      add :description, :string
      add :due_date, :date
      add :status_id, references(:statuses, on_delete: :nothing)
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:actions, [:status_id])
    create index(:actions, [:owner_id])
  end
end
