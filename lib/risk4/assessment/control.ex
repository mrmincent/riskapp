defmodule Risk4.Assessment.Control do
  use Ecto.Schema
  import Ecto.Changeset

  schema "controls" do
    field :description, :string
    field :name, :string
    many_to_many :riskassessments, Risk4.Assessment.RiskAssessment, join_through: Risk4.Assessment.AssessmentControl
    belongs_to :status, Risk4.Shared.Status
    belongs_to :owner, Risk4.Shared.User

    timestamps()
  end

  @doc false
  def changeset(control, attrs) do
    control
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> foreign_key_constraint(:status_id)
    |> foreign_key_constraint(:user_id)
  end
end
