defmodule CanaryPoc.Models.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :description, :string
    field :status, :string, default: "active"
    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :description, :status])
    |> validate_required([:name, :status])
    |> validate_length(:name, min: 3)
    |> validate_inclusion(:status, ["active", "inactive"])
  end
end
