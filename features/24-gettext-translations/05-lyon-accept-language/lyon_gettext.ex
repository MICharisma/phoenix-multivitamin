defmodule PhoenixMultivitaminWeb.LyonGettext do
  @moduledoc false
  use Gettext.Backend,
    otp_app: :phoenix_multivitamin,
    priv: "priv/gettext_24/05-lyon-accept-language"
end
