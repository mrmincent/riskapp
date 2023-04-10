defmodule Risk4.Repo.Migrations.UpdateRiskassessmentAddScopeConstraintsAssumptions do
  use Ecto.Migration

  def change do
    alter table(:riskassessments) do
      add :scope, :text
      add :assumptions, :text
      add :constraints, :text
    end
  end
end
