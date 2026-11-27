# Mailers with Swoosh · 01 · Medellín Guatapé mailer
#
# Teaches:
# - String.Chars so the brief can join a text_body pipeline

defimpl String.Chars, for: PhoenixMultivitaminWeb.MedellinGuatapeWatchBrief do
  def to_string(%{controller: controller, craft: craft, runway: runway, qnh: qnh}) do
    "#{controller} holds #{craft} on #{runway} at QNH #{qnh}"
  end
end
