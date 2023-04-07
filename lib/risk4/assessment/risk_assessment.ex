defmodule Risk4.Assessment.RiskAssessment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "riskassessments" do
    field :consequences, :string
    field :description, :string
    field :due_date, :date
    field :name, :string
    field :postcontrol_impact, :integer
    field :postcontrol_likelihood, :integer
    field :postcontrol_risk, :integer
    field :precontrol_impact, :integer
    field :precontrol_likelihood, :integer
    field :precontrol_risk, :integer
    field :start_date, :date
    belongs_to :risk_owner, Risk4.Shared.User
    belongs_to :status, Risk4.Shared.Status
    many_to_many :threats, Risk4.Assessment.Threat, join_through: Risk4.Assessment.AssessmentThreat, join_keys: [riskassessment_id: :id, threat_id: :id], on_replace: :delete
    many_to_many :vulnerabilities, Risk4.Assessment.Vulnerability, join_through: Risk4.Assessment.AssessmentVulnerability
    many_to_many :controls, Risk4.Assessment.Control, join_through: Risk4.Assessment.AssessmentControl
    many_to_many :items, Risk4.Asset.Item, join_through: Risk4.Assessment.AssessmentItem
    many_to_many :actions, Risk4.Assessment.Action, join_through: Risk4.Assessment.AssessmentAction



    timestamps()
  end

  @doc false
  def changeset(risk_assessment, attrs) do

    threats = Map.get(attrs, "threats", [])
    risk_assessment
    |> cast(attrs, [:name, :description, :start_date, :due_date, :precontrol_impact, :precontrol_likelihood, :precontrol_risk, :postcontrol_impact, :postcontrol_likelihood, :postcontrol_risk, :consequences, :status_id, :risk_owner_id])
    |> validate_required([:name, :description, :start_date, :due_date, :precontrol_impact, :precontrol_likelihood, :precontrol_risk, :postcontrol_impact, :postcontrol_likelihood, :postcontrol_risk, :consequences, :status_id, :risk_owner_id])
    |> foreign_key_constraint(:status_id)
    |> put_assoc(:threats, threats)
  end
end
