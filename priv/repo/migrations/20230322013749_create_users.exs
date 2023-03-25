defmodule Risk4.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :fname, :string
      add :lname, :string
      add :email, :string
      add :phone, :string
      add :level, :integer
      add :avatar, :string
      add :manager_id, references(:users, on_delete: :nothing)
      add :status_id, references(:statuses, on_delete: :nothing)
      timestamps()
    end

    create index(:users, [:manager_id])
  end
end
