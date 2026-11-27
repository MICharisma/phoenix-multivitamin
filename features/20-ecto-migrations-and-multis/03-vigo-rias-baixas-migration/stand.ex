# Ecto migrations and multis · 03 · Vigo Rías Baixas migration
#
# Teaches:
# - Parent stand that bay cards reference

defmodule PhoenixMultivitamin.VigoStand do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "vigo_stands" do
    field :label, :string
    field :harbour, :string
    has_many :bay_cards, PhoenixMultivitamin.VigoBayCard

    timestamps(type: :utc_datetime)
  end

  def changeset(stand, attrs) do
    stand
    |> cast(attrs, [:label, :harbour])
    |> validate_required([:label, :harbour])
  end
end
