# Ecto queries and contexts · 08 · Quito altitude tags
#
# Teaches:
# - SQLite-safe fragment("lower(?)", ...) for case-insensitive match
# - fragment string concat for a display label

defmodule PhoenixMultivitamin.QuitoTagDesk do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.QuitoCargoTag
  alias PhoenixMultivitamin.Repo

  def list_tags_matching(needle) when is_binary(needle) do
    lowered = String.downcase(needle)

    Repo.all(
      from tag in QuitoCargoTag,
        where: fragment("lower(?)", tag.label) == ^lowered,
        order_by: [asc: tag.id],
        select: %{
          id: tag.id,
          display: fragment("? || ' @ ' || CAST(? AS TEXT) || ' ft'", tag.label, tag.altitude_ft),
          altitude_ft: tag.altitude_ft
        }
    )
  end
end
