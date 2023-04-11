defmodule Risk4.Asset.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :availablity, :integer
    field :confidentiality, :integer
    field :integrity, :integer
    field :justification, :string
    field :name, :string
    field :value, :integer
    belongs_to :status, Risk4.Shared.Status
    belongs_to :asset_type, Risk4.Asset.Asset_Type
    belongs_to :category, Risk4.Shared.Category
    many_to_many :riskassessments, Risk4.Assessment.RiskAssessment,
      join_through: Risk4.Assessment.AssessmentItem, join_keys: [item_id: :id, riskassessment_id: :id]

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :confidentiality, :integrity, :availablity, :value, :justification, :status_id, :category_id, :asset_type_id])
    |> validate_required([:name, :confidentiality, :integrity, :availablity, :value, :justification, :status_id])
    |> foreign_key_constraint(:status_id)
    |> foreign_key_constraint(:asset_type)
    |> foreign_key_constraint(:category)
  end
end
