defmodule Risk4.Repo.Migrations.CreateAssessmentActions do
  use Ecto.Migration

  def change do
    create table(:assessment_actions) do
      add :riskassessment_id, references(:riskassessments, on_delete: :nothing)
      add :action_id, references(:actions, on_delete: :nothing)

      timestamps()
    end

    create index(:assessment_actions, [:riskassessment_id])
    create index(:assessment_actions, [:action_id])
  end
end
