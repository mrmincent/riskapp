defmodule Risk4.Repo.Migrations.CreateStatuses do
  use Ecto.Migration

  def change do
    create table(:statuses) do
      add :name, :string
      add :description, :string

      timestamps()
    end
  end
end
