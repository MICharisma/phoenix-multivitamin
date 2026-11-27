defmodule PhoenixMultivitamin.SharjahCreekHails do
  @moduledoc false
  import Ecto.Query

  alias PhoenixMultivitamin.{Repo, SharjahCreekHail}

  @topic "sharjah:creek-hails"

  def subscribe, do: Phoenix.PubSub.subscribe(PhoenixMultivitamin.PubSub, @topic)

  def recent_hails(limit \\ 10) do
    SharjahCreekHail
    |> order_by(desc: :id)
    |> limit(^limit)
    |> Repo.all()
  end

  def change_hail(attrs \\ %{}), do: SharjahCreekHail.changeset(%SharjahCreekHail{}, attrs)

  def log_hail(attrs) do
    %SharjahCreekHail{}
    |> SharjahCreekHail.changeset(attrs)
    |> Repo.insert()
    |> tap(&announce/1)
  end

  defp announce({:ok, %SharjahCreekHail{} = hail}) do
    Phoenix.PubSub.broadcast(PhoenixMultivitamin.PubSub, @topic, {__MODULE__, :hail_logged, hail})
  end

  defp announce({:error, _changeset}), do: :not_logged
end
