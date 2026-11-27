# Ecto migrations and multis · 12 · Vitoria Basque multi
#
# Teaches:
# - String.Chars lives in its own file from the struct

defimpl String.Chars, for: PhoenixMultivitamin.VitoriaHandoverResult do
  def to_string(%PhoenixMultivitamin.VitoriaHandoverResult{
        bay: bay,
        receipt_code: code,
        souls: souls
      }) do
    "#{bay} · #{code} · #{souls} souls"
  end
end
