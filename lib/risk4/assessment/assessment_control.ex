defmodule Risk4.Assessment.AssessmentControl do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assessment_controls" do

    belongs_to :riskassessment, Risk4.Assessment.RiskAssessment
    belongs_to :control, Risk4.Assessment.Control

    timestamps()
  end

  @doc false
  def changeset(assessment_control, attrs) do
    assessment_control
    |> cast(attrs, [])
    |> validate_required([])
    |> foreign_key_constraint(:riskassessment_id)
    |> foreign_key_constraint(:control_id)
  end
end
