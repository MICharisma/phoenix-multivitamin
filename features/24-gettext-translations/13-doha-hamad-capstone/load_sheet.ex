defmodule PhoenixMultivitaminWeb.DohaLoadSheet do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :flight, :string
    field :bags, :integer
  end

  def changeset(sheet, attrs) do
    sheet
    |> cast(attrs, [:flight, :bags])
    |> validate_required([:flight, :bags])
    |> validate_number(:bags, greater_than: 0)
  end

  def translate_errors(changeset) do
    backend = PhoenixMultivitaminWeb.DohaGettext

    changeset.errors
    |> Enum.map(fn {field, {msg, opts}} ->
      translated =
        if count = opts[:count] do
          Gettext.dngettext(backend, "errors", msg, msg, count, opts)
        else
          Gettext.dgettext(backend, "errors", msg, opts)
        end

      {field, translated}
    end)
  end
end
