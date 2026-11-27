# Mailers with Swoosh · 09 · Campo Grande Pantanal mailer
#
# Teaches:
# - Synchronous Mailer.deliver/1 versus Task.async delivery (Oban-free)
# - Awaiting the task and returning the same email shape either way

defmodule PhoenixMultivitaminWeb.CampoGrandePantanalMailer do
  @moduledoc false
  import Swoosh.Email

  alias PhoenixMultivitamin.Mailer

  def build_wetland_brief(ranger, craft, lagoon) do
    new()
    |> to({ranger, "#{slug(ranger)}@sbcg.gov.br"})
    |> from({"Campo Grande Pantanal desk", "pantanal@sbcg.gov.br"})
    |> subject("Pantanal brief · #{lagoon}")
    |> text_body("#{ranger} lifts the #{craft} over #{lagoon} at first light.")
  end

  def deliver_now(ranger, craft, lagoon) do
    email = build_wetland_brief(ranger, craft, lagoon)

    case Mailer.deliver(email) do
      {:ok, meta} -> {:ok, :sync, email, meta}
      {:error, reason} -> {:error, reason}
    end
  end

  def deliver_async(ranger, craft, lagoon) do
    email = build_wetland_brief(ranger, craft, lagoon)

    task =
      Task.async(fn ->
        case Mailer.deliver(email) do
          {:ok, meta} -> {:ok, email, meta}
          {:error, reason} -> {:error, reason}
        end
      end)

    case Task.await(task, 5_000) do
      {:ok, emailed, meta} -> {:ok, :async, emailed, meta}
      {:error, reason} -> {:error, reason}
    end
  end

  defp slug(name), do: name |> String.downcase() |> String.replace(" ", "-")
end
