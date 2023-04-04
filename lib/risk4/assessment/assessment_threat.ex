defmodule Risk4.Assessment.AssessmentThreat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assessment_threats" do

    belongs_to :riskassessment, Risk4.Assessment.RiskAssessment
    belongs_to :threat, Risk4.Assessment.Threat

    timestamps()
  end

  @doc false
  def changeset(assessment_threat, attrs) do
    assessment_threat
    |> cast(attrs, [])
    |> validate_required([])
    |> foreign_key_constraint(:riskassessment_id)
    |> foreign_key_constraint(:threat_id)
  end
end
