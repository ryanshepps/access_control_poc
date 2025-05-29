defmodule CanaryPoc.Models.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :role, :string, default: "employee"
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :role])
    |> validate_required([:email, :role])
    |> validate_length(:name, min: 3)
    |> validate_inclusion(:role, ["employee", "supervisor", "owner", "admin"])
  end
end
