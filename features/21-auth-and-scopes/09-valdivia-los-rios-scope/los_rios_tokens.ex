# Auth and scopes · 09 · Valdivia Los Ríos scope
#
# Teaches:
# - mint_login_token/1 encodes a clerk name with Base.encode64
# - redeem_login_token/1 decodes and builds a %LosRiosScope{}
# - with for the redeem pipeline steps

defmodule PhoenixMultivitaminWeb.LosRiosTokens do
  @moduledoc false

  alias PhoenixMultivitaminWeb.LosRiosScope

  @prefix "los-rios-v1:"

  def mint_login_token(clerk) when is_binary(clerk) do
    (@prefix <> clerk) |> Base.encode64(padding: false)
  end

  def redeem_login_token(token) when is_binary(token) do
    with {:ok, raw} <- Base.decode64(token, padding: false),
         @prefix <> clerk <- raw,
         true <- clerk != "" do
      {:ok, LosRiosScope.for_clerk(clerk, token)}
    else
      _ -> {:error, :invalid_token}
    end
  end

  def redeem_login_token(_), do: {:error, :invalid_token}
end
