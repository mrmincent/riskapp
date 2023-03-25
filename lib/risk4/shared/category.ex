defmodule Risk4.Shared.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :description, :string
    field :name, :string
    belongs_to :status, Risk4.Shared.Status

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    IO.inspect(category)
    IO.inspect(attrs)
    category
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description, :status])
    |> foreign_key_constraint(:status)


  end
end
