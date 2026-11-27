defmodule PhoenixMultivitaminWeb.MoscowGettext do
  @moduledoc false
  use Gettext.Backend,
    otp_app: :phoenix_multivitamin,
    priv: "priv/gettext_24/08-moscow-sheremetyevo-plurals"
end
