%{
  number: 25,
  slug: "25-testing",
  title: "Testing",
  summary:
    "ConnTest, LiveViewTest, ChannelCase, SQL sandbox, and assertions that lock the board rather than the markup fashion of the week.",
  official: "https://hexdocs.pm/phoenix/testing.html",
  slots: [
    %{
      number: 1,
      slug: "01-port-moresby-atis-desk",
      title: "Port Moresby ATIS desk",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.PortMoresbyAtisDeskLive
    },
    %{
      number: 2,
      slug: "02-cairns-reef-click-board",
      title: "Cairns reef click board",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.CairnsReefClickBoardLive
    },
    %{
      number: 3,
      slug: "03-darwin-fuel-form",
      title: "Darwin fuel form",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.DarwinFuelFormLive
    },
    %{
      number: 4,
      slug: "04-broome-sector-hop",
      title: "Broome sector hop",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.BroomeSectorHopLive
    },
    %{
      number: 5,
      slug: "05-kalgoorlie-wind-async",
      title: "Kalgoorlie wind async",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.KalgoorlieWindAsyncLive
    },
    %{
      number: 6,
      slug: "06-hobart-frost-cell",
      title: "Hobart frost cell",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.HobartFrostCellLive
    },
    %{
      number: 7,
      slug: "07-launceston-tower-channel",
      title: "Launceston tower channel",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.LauncestonTowerChannelLive
    },
    %{
      number: 8,
      slug: "08-dunedin-fuel-ledger",
      title: "Dunedin fuel ledger",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.DunedinFuelLedgerLive
    },
    %{
      number: 9,
      slug: "09-christchurch-watch-session",
      title: "Christchurch watch session",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.ChristchurchWatchSessionLive
    },
    %{
      number: 10,
      slug: "10-wellington-tag-range",
      title: "Wellington tag range",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.WellingtonTagRangeLive
    },
    %{
      number: 11,
      slug: "11-rotorua-qnh-doctest",
      title: "Rotorua QNH doctest",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.RotoruaQnhDoctestLive
    },
    %{
      number: 12,
      slug: "12-taupo-beacon-receive",
      title: "Taupō beacon receive",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.TaupoBeaconReceiveLive
    },
    %{
      number: 13,
      slug: "13-auckland-log-vault",
      title: "Auckland log vault",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.AucklandLogVaultLive
    }
  ]
}
