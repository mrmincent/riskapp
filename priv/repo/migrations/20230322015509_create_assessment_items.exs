defmodule Risk4.Repo.Migrations.CreateAssessmentItems do
  use Ecto.Migration

  def change do
    create table(:assessment_items) do
      add :riskassessment_id, references(:riskassessments, on_delete: :nothing)
      add :item_id, references(:items, on_delete: :nothing)

      timestamps()
    end

    create index(:assessment_items, [:riskassessment_id])
    create index(:assessment_items, [:item_id])
  end
end
