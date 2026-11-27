defmodule PhoenixMultivitaminWeb.CairoGettext do
  @moduledoc false
  use Gettext.Backend,
    otp_app: :phoenix_multivitamin,
    priv: "priv/gettext_24/09-cairo-egyptair-bindings"
end
