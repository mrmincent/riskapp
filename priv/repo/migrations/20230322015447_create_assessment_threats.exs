defmodule Risk4.Repo.Migrations.CreateAssessmentThreats do
  use Ecto.Migration

  def change do
    create table(:assessment_threats) do
      add :riskassessment_id, references(:riskassessments, on_delete: :nothing)
      add :threat_id, references(:threats, on_delete: :nothing)

      timestamps()
    end

    create index(:assessment_threats, [:riskassessment_id])
    create index(:assessment_threats, [:threat_id])
  end
end
