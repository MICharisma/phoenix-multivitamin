# Ecto queries and contexts · 06 · Santiago late preload
#
# Teaches:
# - Fetch first, then Repo.preload/2 (contrast with join-preload)
# - A second query loads the association after the fact

defmodule PhoenixMultivitamin.SantiagoManifestDesk do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.Repo
  alias PhoenixMultivitamin.SantiagoManifest

  def list_manifests_with_airline do
    SantiagoManifest
    |> order_by([manifest], asc: manifest.awb)
    |> Repo.all()
    |> Repo.preload(:santiago_airline)
  end
end
