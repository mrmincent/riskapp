defmodule Risk4.Shared.Status do
  use Ecto.Schema
  import Ecto.Changeset

  schema "statuses" do
    field :description, :string
    field :name, :string

    has_many :riskassessments, Risk4.Assessment.RiskAssessment
    has_many :categories, Risk4.Shared.Category
    has_many :items, Risk4.Asset.Item
    has_many :asset_types, Risk4.Asset.Asset_Type
    has_many :users, Risk4.Shared.User
    has_many :actions, Risk4.Assessment.Action
    has_many :threats, Risk4.Assessment.Threat
    has_many :vulnerabilities, Risk4.Assessment.Vulnerability
    has_many :controls, Risk4.Assessment.Control

    timestamps()
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
