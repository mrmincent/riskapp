defmodule Risk4.Assessment.Action do
  use Ecto.Schema
  import Ecto.Changeset

  schema "actions" do
    field :description, :string
    field :due_date, :date
    field :title, :string
    belongs_to :status, Risk4.Shared.Status
    belongs_to :owner, Risk4.Shared.User
    many_to_many :riskassessments, Risk4.Assessment.RiskAssessment, join_through: Risk4.Assessment.AssessmentVulnerability

    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:title, :description, :due_date, :status_id, :owner_id])
    |> validate_required([:title, :description, :due_date, :status_id, :owner_id])
    |> foreign_key_constraint(:owner)
    |> foreign_key_constraint(:status_id)
  end
end
