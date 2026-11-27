# Ecto migrations and multis · 09 · Zaragoza Ebro multi
#
# Teaches:
# - Draft schema with a status field that Multi.update flips

defmodule PhoenixMultivitamin.ZaragozaEbroDraft do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "zaragoza_ebro_drafts" do
    field :clerk, :string
    field :craft, :string
    field :route, :string
    field :status, :string, default: "draft"

    timestamps(type: :utc_datetime)
  end

  def changeset(draft, attrs) do
    draft
    |> cast(attrs, [:clerk, :craft, :route, :status])
    |> validate_required([:clerk, :craft, :route, :status])
    |> validate_inclusion(:status, ["draft", "filed"])
  end
end
