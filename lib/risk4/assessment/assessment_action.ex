defmodule Risk4.Assessment.AssessmentAction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assessment_actions" do

    field :riskassessment_id, :id
    field :action_id, :id

    timestamps()
  end

  @doc false
  def changeset(assessment_action, attrs) do
    assessment_action
    |> cast(attrs, [])
    |> validate_required([])
  end
end
