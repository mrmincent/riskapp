defmodule Risk4.Repo.Migrations.UpdateRiskassessmentNewDescriptionFields do
  use Ecto.Migration

  def change do
    alter table(:riskassessments) do
      add :threatdescription, :text
      add :vulnerabilitydescription, :text
      add :controlsdescription, :text
      add :itemsdescription, :text
      add :risksummary, :text
    end
  end
end
