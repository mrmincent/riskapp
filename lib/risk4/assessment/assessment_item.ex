defmodule Risk4.Assessment.AssessmentItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assessment_items" do

    field :riskassessment_id, :id
    field :item_id, :id

    timestamps()
  end

  @doc false
  def changeset(assessment_item, attrs) do
    assessment_item
    |> cast(attrs, [])
    |> validate_required([])
  end
end
