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
    field :scope, :string
    field :assumptions, :string
    field :constraints, :string
    field :threatdescription, :string
    field :controlsdescription, :string
    field :itemsdescription, :string
    field :vulnerabilitydescription, :string
    field :risksummary, :string
    field :constraintsdescription, :string
    belongs_to :risk_owner, Risk4.Shared.User
    belongs_to :status, Risk4.Shared.Status
    many_to_many :threats, Risk4.Assessment.Threat, join_through: Risk4.Assessment.AssessmentThreat, join_keys: [riskassessment_id: :id, threat_id: :id], on_replace: :delete
    many_to_many :vulnerabilities, Risk4.Assessment.Vulnerability, join_through: Risk4.Assessment.AssessmentVulnerability, join_keys: [riskassessment_id: :id, vulnerability_id: :id], on_replace: :delete
    many_to_many :controls, Risk4.Assessment.Control, join_through: Risk4.Assessment.AssessmentControl, join_keys: [riskassessment_id: :id, control_id: :id], on_replace: :delete
    many_to_many :items, Risk4.Asset.Item, join_through: Risk4.Assessment.AssessmentItem, join_keys: [riskassessment_id: :id, item_id: :id], on_replace: :delete
    many_to_many :actions, Risk4.Assessment.Action, join_through: Risk4.Assessment.AssessmentAction, join_keys: [riskassessment_id: :id, action_id: :id], on_replace: :delete



    timestamps()
  end

  @doc false
  def changeset(risk_assessment, attrs) do

    threats = Map.get(attrs, "threats", [])
    items = Map.get(attrs, "items", [])
    controls = Map.get(attrs, "controls", [])
    vulnerabilities = Map.get(attrs, "vulnerabilities", [])

    risk_assessment
    |> cast(attrs, [:name, :description, :start_date, :due_date, :precontrol_impact, :precontrol_likelihood, :precontrol_risk, :postcontrol_impact, :postcontrol_likelihood, :postcontrol_risk, :consequences, :status_id, :risk_owner_id, :scope, :assumptions, :constraints, :threatdescription,
                   :controlsdescription, :itemsdescription, :vulnerabilitydescription, :risksummary, :constraintsdescription])
    |> validate_required([:name, :description, :start_date, :due_date, :status_id, :risk_owner_id])
    |> foreign_key_constraint(:status_id)
    |> put_assoc(:threats, threats)
    |> put_assoc(:controls, controls)
    |> put_assoc(:items, items)
    |> put_assoc(:vulnerabilities, vulnerabilities)
  end
end
