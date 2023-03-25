defmodule Risk4.Repo.Migrations.CreateRiskassessments do
  use Ecto.Migration

  def change do
    create table(:riskassessments) do
      add :name, :string
      add :description, :string
      add :start_date, :date
      add :due_date, :date
      add :precontrol_impact, :integer
      add :precontrol_likelihood, :integer
      add :precontrol_risk, :integer
      add :postcontrol_impact, :integer
      add :postcontrol_likelihood, :integer
      add :postcontrol_risk, :integer
      add :consequences, :string
      add :risk_owner_id, references(:users, on_delete: :nothing)
      add :status_id, references(:statuses, on_delete: :nothing)


      timestamps()
    end

    create index(:riskassessments, [:risk_owner_id])
  end
end
