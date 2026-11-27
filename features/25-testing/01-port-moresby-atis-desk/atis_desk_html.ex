defmodule PhoenixMultivitaminWeb.PortMoresbyAtisDeskHTML do
  @moduledoc false
  use PhoenixMultivitaminWeb, :html

  def show(assigns) do
    ~H"""
    <Layouts.app flash={@flash} variant={:catalog}>
      <p class="breadcrumbs">
        <.link navigate={~p"/"}>Catalog</.link> · Testing · 01 · Port Moresby ATIS desk
      </p>

      <h1>Port Moresby ATIS desk</h1>
      <p class="lede">
        Observer {@atis.observer} at {@atis.station}. Information {@atis.information} for the {@atis.craft}.
      </p>

      <dl id="atis-board">
        <div>
          <dt>Station</dt>
          <dd id="atis-station">{@atis.station}</dd>
        </div>
        <div>
          <dt>Wind</dt>
          <dd id="atis-wind">{@atis.wind}</dd>
        </div>
        <div>
          <dt>QNH</dt>
          <dd id="atis-qnh">{@atis.qnh}</dd>
        </div>
      </dl>
    </Layouts.app>
    """
  end
end
