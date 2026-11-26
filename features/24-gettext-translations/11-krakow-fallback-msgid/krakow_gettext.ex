defmodule PhoenixMultivitaminWeb.KrakowGettext do
  @moduledoc false
  use Gettext.Backend,
    otp_app: :phoenix_multivitamin,
    priv: "priv/gettext_24/11-krakow-fallback-msgid"
end
