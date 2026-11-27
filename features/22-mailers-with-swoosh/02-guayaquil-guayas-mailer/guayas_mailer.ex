# Mailers with Swoosh · 02 · Guayaquil Guayas mailer
#
# Teaches:
# - html_body/2 beside text_body/2 on one email
# - cc/2, bcc/2, and reply_to/2 with mixed recipient shapes
# - with/else validating the duty officer before the pipeline runs

defmodule PhoenixMultivitaminWeb.GuayaquilGuayasMailer do
  @moduledoc false
  import Swoosh.Email

  @officers %{
    "Marisol" => "marisol@segu.gov.ec",
    "Esteban" => "esteban@segu.gov.ec"
  }

  def compose_tide_notice(officer_name, opts \\ []) when is_list(opts) do
    with {:ok, officer_email} <- fetch_officer(officer_name) do
      tide = Keyword.get(opts, :tide, "flood")
      craft = Keyword.get(opts, :craft, "DHC-6 Twin Otter")

      email =
        new()
        |> to({officer_name, officer_email})
        |> cc({"Guayas river desk", "river@segu.gov.ec"})
        |> bcc([
          {"Ops archive", "archive@segu.gov.ec"},
          "shift-copy@segu.gov.ec"
        ])
        |> from({"José Joaquín de Olmedo tides", "tides@segu.gov.ec"})
        |> reply_to({"Duty hydrologist", "hydro@segu.gov.ec"})
        |> subject("Guayas #{tide} notice for #{officer_name}")
        |> text_body(text_notice(officer_name, craft, tide))
        |> html_body(html_notice(officer_name, craft, tide))

      {:ok, email}
    end
  end

  defp fetch_officer(name) do
    case Map.fetch(@officers, name) do
      {:ok, email} -> {:ok, email}
      :error -> {:error, :unknown_officer}
    end
  end

  defp text_notice(officer, craft, tide) do
    "#{officer}: the Guayas #{tide} window clears #{craft} for the mangrove hop."
  end

  defp html_notice(officer, craft, tide) do
    """
    <p id="tide-mail">#{officer}, the Guayas <strong>#{tide}</strong> window clears
    the #{craft} for the mangrove hop.</p>
    """
  end
end
