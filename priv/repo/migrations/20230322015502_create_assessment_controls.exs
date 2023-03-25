defmodule Risk4.Repo.Migrations.CreateAssessmentControls do
  use Ecto.Migration

  def change do
    create table(:assessment_controls) do
      add :riskassessment_id, references(:riskassessments, on_delete: :nothing)
      add :control_id, references(:controls, on_delete: :nothing)

      timestamps()
    end

    create index(:assessment_controls, [:riskassessment_id])
    create index(:assessment_controls, [:control_id])
  end
end
