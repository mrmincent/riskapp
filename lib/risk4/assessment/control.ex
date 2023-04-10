defmodule Risk4.Assessment.Control do
  use Ecto.Schema
  import Ecto.Changeset

  schema "controls" do
    field :description, :string
    field :name, :string
    many_to_many :riskassessments, Risk4.Assessment.RiskAssessment,
      join_through: Risk4.Assessment.AssessmentControl, join_keys: [control_id: :id, riskassessment_id: :id]

    belongs_to :status, Risk4.Shared.Status
    belongs_to :owner, Risk4.Shared.User

    timestamps()
  end

  @doc false
  def changeset(control, attrs) do
    control
    |> cast(attrs, [:name, :description, :status_id, :owner_id])
    |> validate_required([:name, :description, :status_id])
    |> foreign_key_constraint(:status_id)
    |> foreign_key_constraint(:user_id)
  end
end
