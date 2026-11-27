# Telemetry and LiveDashboard · 06 · Lusaka Copperbelt span
#
# Teaches:
# - :telemetry.span/3 emits EventPrefix ++ [exception] when the function raises
# - Exception metadata carries :kind, :reason, and :stacktrace; start still fires

defmodule PhoenixMultivitaminWeb.LusakaCopperbeltSpan do
  @moduledoc false

  @prefix [:lusaka, :copperbelt, :load]

  def prefix, do: @prefix
  def start_event, do: @prefix ++ [:start]
  def stop_event, do: @prefix ++ [:stop]
  def exception_event, do: @prefix ++ [:exception]

  def load(cargo, tonnes) when is_binary(cargo) and is_number(tonnes) and tonnes > 0 do
    metadata = %{apron: "Lusaka International", belt: "Copperbelt", craft: "IL-76"}

    try do
      :telemetry.span(@prefix, metadata, fn ->
        cond do
          unstable_cargo?(cargo) ->
            raise ArgumentError, "unstable Copperbelt cargo: #{cargo}"

          true ->
            result = %{cargo: cargo, tonnes: tonnes, status: :stowed}
            {result, %{tonnes: tonnes}, %{cargo: cargo}}
        end
      end)
    rescue
      error ->
        {:error, {:load_failed, Exception.message(error)}}
    end
  end

  def load(_cargo, tonnes) when tonnes <= 0 do
    {:error, :empty_hold}
  end

  defp unstable_cargo?(cargo) do
    String.contains?(String.downcase(cargo), "uncrated")
  end
end
