# Testing · 03 · Darwin fuel slip
#
# Teaches:
# - An embedded schema is enough for to_form/1 under LiveViewTest

defmodule PhoenixMultivitamin.DarwinFuelSlip do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :litres, :integer
    field :bay, :string
  end

  def changeset(slip \\ %__MODULE__{}, attrs) do
    slip
    |> cast(attrs, [:litres, :bay])
    |> validate_required([:litres, :bay])
    |> validate_number(:litres, greater_than: 0, less_than_or_equal_to: 3_200)
    |> validate_inclusion(:bay, ~w(north south))
  end
end
