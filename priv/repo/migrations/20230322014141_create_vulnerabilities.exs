defmodule Risk4.Repo.Migrations.CreateVulnerabilities do
  use Ecto.Migration

  def change do
    create table(:vulnerabilities) do
      add :name, :string
      add :description, :string
      add :status_id, references(:statuses, on_delete: :nothing)

      timestamps()
    end

    create index(:vulnerabilities, [:status_id])
  end
end
