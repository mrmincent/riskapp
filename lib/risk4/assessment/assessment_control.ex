defmodule Risk4.Assessment.AssessmentControl do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assessment_controls" do

    field :riskassessment_id, :id
    field :control_id, :id

    timestamps()
  end

  @doc false
  def changeset(assessment_control, attrs) do
    assessment_control
    |> cast(attrs, [])
    |> validate_required([])
  end
end
