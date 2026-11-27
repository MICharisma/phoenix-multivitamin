# Ecto migrations and multis · 09 · Zaragoza Ebro multi
#
# Teaches:
# - Named Multi steps built with Enum.reduce/3
# - Multi.update/3 files the draft after insert

defmodule PhoenixMultivitamin.ZaragozaEbroDesk do
  @moduledoc false

  alias Ecto.Multi
  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.ZaragozaEbroDraft

  @steps [:insert_draft, :file_draft]

  def file_route(route) when is_binary(route) do
    @steps
    |> Enum.reduce(Multi.new(), &append_step(&1, &2, route))
    |> Repo.transaction()
  end

  defp append_step(:insert_draft, multi, route) do
    Multi.insert(
      multi,
      :insert_draft,
      ZaragozaEbroDraft.changeset(%ZaragozaEbroDraft{}, %{
        clerk: "Pilar",
        craft: "Airbus A330-200",
        route: route,
        status: "draft"
      })
    )
  end

  defp append_step(:file_draft, multi, _route) do
    Multi.update(multi, :file_draft, fn %{insert_draft: draft} ->
      ZaragozaEbroDraft.changeset(draft, %{status: "filed"})
    end)
  end
end
