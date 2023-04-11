defmodule Risk4.Assessment.AssessmentItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assessment_items" do

    belongs_to :riskassessment, Risk4.Assessment.RiskAssessment
    belongs_to :item, Risk4.Asset.Item

    timestamps()
  end

  @doc false
  def changeset(assessment_item, attrs) do
    assessment_item
    |> cast(attrs, [])
    |> validate_required([])
    |> foreign_key_constraint(:riskassessment_id)
    |> foreign_key_constraint(:item_id)
  end
end
