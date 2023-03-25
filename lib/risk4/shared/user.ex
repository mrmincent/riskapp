defmodule Risk4.Shared.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :avatar, :string
    field :email, :string
    field :fname, :string
    field :level, :integer
    field :lname, :string
    field :phone, :string
    belongs_to :status, Risk4.Shared.Status
    belongs_to :manager, Risk4.Shared.User
    has_many :subordinates, Risk4.Shared.User, foreign_key: :manager_id

    many_to_many :riskassessments, Risk4.Assessment.RiskAssessment, join_through: Risk4.Assessment.AssessmentVulnerability

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:fname, :lname, :email, :phone, :level, :avatar])
    |> validate_required([:fname, :lname, :email, :phone, :level, :avatar])
    |> foreign_key_constraint(:manager_id, name: :users_manager_id_fkey)
    |> foreign_key_constraint(:status)
  end
end
