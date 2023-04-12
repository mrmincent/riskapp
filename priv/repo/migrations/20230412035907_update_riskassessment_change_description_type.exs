defmodule Risk4.Repo.Migrations.UpdateRiskassessmentChangeDescriptionType do
  use Ecto.Migration

  def change do
    alter table(:riskassessments) do
      modify :description, :text
    end
  end
end
