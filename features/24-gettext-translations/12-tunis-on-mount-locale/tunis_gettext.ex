defmodule PhoenixMultivitaminWeb.TunisGettext do
  @moduledoc false
  use Gettext.Backend,
    otp_app: :phoenix_multivitamin,
    priv: "priv/gettext_24/12-tunis-on-mount-locale"
end
