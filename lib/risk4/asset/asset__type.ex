defmodule Risk4.Asset.Asset_Type do
  use Ecto.Schema
  import Ecto.Changeset

  schema "asset_types" do
    field :description, :string
    field :name, :string
    belongs_to :status, Risk4.Shared.Status
    has_many :items, Risk4.Asset.Item, foreign_key: :id

    timestamps()
  end

  @doc false
  def changeset(asset__type, attrs) do
    asset__type
    |> cast(attrs, [:name, :description, :status_id])
    |> validate_required([:name, :description, :status_id])
    |> foreign_key_constraint(:status_id)
  end
end
