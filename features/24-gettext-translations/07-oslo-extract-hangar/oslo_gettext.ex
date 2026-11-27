defmodule PhoenixMultivitaminWeb.OsloGettext do
  @moduledoc false
  use Gettext.Backend,
    otp_app: :phoenix_multivitamin,
    priv: "priv/gettext_24/07-oslo-extract-hangar"
end
