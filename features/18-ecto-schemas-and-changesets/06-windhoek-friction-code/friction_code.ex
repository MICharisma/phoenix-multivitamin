# Ecto schemas and changesets · 06 · Windhoek friction code
#
# Teaches:
# - A custom Ecto.Type that casts MU codes and dumps a string column

defmodule PhoenixMultivitamin.WindhoekFrictionCode do
  @moduledoc false
  use Ecto.Type

  @codes ~w(GOOD MEDIUM POOR)

  def type, do: :string

  def cast(code) when is_binary(code) do
    normalized = String.upcase(String.trim(code))

    if normalized in @codes do
      {:ok, normalized}
    else
      :error
    end
  end

  def cast(_), do: :error

  def load(code) when is_binary(code), do: {:ok, code}
  def load(_), do: :error

  def dump(code) when code in @codes, do: {:ok, code}
  def dump(_), do: :error
end
