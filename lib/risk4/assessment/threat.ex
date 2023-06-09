defmodule Risk4.Assessment.Threat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "threats" do
    field :description, :string
    field :name, :string
    belongs_to :status, Risk4.Shared.Status
    many_to_many :riskassessments, Risk4.Assessment.RiskAssessment,
      join_through: Risk4.Assessment.AssessmentThreat, join_keys: [threat_id: :id, riskassessment_id: :id]



    timestamps()
  end

  @doc false
  def changeset(threat, attrs) do
    threat
    |> cast(attrs, [:name, :description, :status_id])
    |> validate_required([:name, :description, :status_id])
    |> foreign_key_constraint(:status_id)
  end
end
