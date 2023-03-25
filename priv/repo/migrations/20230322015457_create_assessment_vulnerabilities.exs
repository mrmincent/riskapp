defmodule Risk4.Repo.Migrations.CreateAssessmentVulnerabilities do
  use Ecto.Migration

  def change do
    create table(:assessment_vulnerabilities) do
      add :riskassessment_id, references(:riskassessments, on_delete: :nothing)
      add :vulnerability_id, references(:vulnerabilities, on_delete: :nothing)

      timestamps()
    end

    create index(:assessment_vulnerabilities, [:riskassessment_id])
    create index(:assessment_vulnerabilities, [:vulnerability_id])
  end
end
