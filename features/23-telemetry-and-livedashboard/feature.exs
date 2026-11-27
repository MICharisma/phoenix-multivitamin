%{
  number: 23,
  slug: "23-telemetry-and-livedashboard",
  title: "Telemetry and LiveDashboard",
  summary:
    "telemetry execute, attach, span, metrics, periodic measurements, and LiveDashboard pages that show a station's pulse rather than a blank VM.",
  official: "https://hexdocs.pm/phoenix_live_dashboard/Phoenix.LiveDashboard.html",
  slots: [
    %{
      number: 1,
      slug: "01-kisumu-winam-metrics",
      title: "Kisumu Winam metrics",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.KisumuWinamMetricsLive
    },
    %{
      number: 2,
      slug: "02-mombasa-moi-duration",
      title: "Mombasa Moi duration",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.MombasaMoiDurationLive
    },
    %{
      number: 3,
      slug: "03-pemba-clove-counters",
      title: "Pemba clove counters",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.PembaCloveCountersLive
    },
    %{
      number: 4,
      slug: "04-kilimanjaro-kibo-cycle",
      title: "Kilimanjaro Kibo cycle",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.KilimanjaroKiboCycleLive
    },
    %{
      number: 5,
      slug: "05-lilongwe-lake-counts",
      title: "Lilongwe lake counts",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.LilongweLakeCountsLive
    },
    %{
      number: 6,
      slug: "06-lusaka-copperbelt-span",
      title: "Lusaka Copperbelt span",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.LusakaCopperbeltSpanLive
    },
    %{
      number: 7,
      slug: "07-harare-highveld-gauges",
      title: "Harare Highveld gauges",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.HarareHighveldGaugesLive
    },
    %{
      number: 8,
      slug: "08-gaborone-kalahari-throughput",
      title: "Gaborone Kalahari throughput",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.GaboroneKalahariThroughputLive
    },
    %{
      number: 9,
      slug: "09-maputo-indian-ocean-wait",
      title: "Maputo Indian Ocean wait",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.MaputoIndianOceanWaitLive
    },
    %{
      number: 10,
      slug: "10-beira-sofala-duration",
      title: "Beira Sofala duration",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.BeiraSofalaDurationLive
    },
    %{
      number: 11,
      slug: "11-toamasina-vanilla-gauge",
      title: "Toamasina vanilla gauge",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.ToamasinaVanillaGaugeLive
    },
    %{
      number: 12,
      slug: "12-reunion-piton-tickets",
      title: "Réunion Piton tickets",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.ReunionPitonTicketsLive
    },
    %{
      number: 13,
      slug: "13-mayotte-lagoon-metrics",
      title: "Mayotte lagoon metrics",
      bottled: true,
      live_module: PhoenixMultivitaminWeb.MayotteLagoonMetricsLive
    }
  ]
}
