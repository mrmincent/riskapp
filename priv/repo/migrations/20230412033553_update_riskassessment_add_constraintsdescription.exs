defmodule Risk4.Repo.Migrations.UpdateRiskassessmentAddConstraintsdescription do
  use Ecto.Migration

  def change do
    alter table(:riskassessments) do
      add :constraintsdescription, :text
    end
  end
end
