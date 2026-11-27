# Ecto migrations and multis · 12 · Vitoria Basque multi
#
# Teaches:
# - @enforce_keys defstruct for the context return value

defmodule PhoenixMultivitamin.VitoriaHandoverResult do
  @moduledoc false

  @enforce_keys [:bay, :receipt_code, :souls]
  defstruct [:bay, :receipt_code, :souls]
end
