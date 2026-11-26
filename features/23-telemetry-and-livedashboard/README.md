# Telemetry and LiveDashboard

`:telemetry.execute`, attach/detach, spans, Telemetry.Metrics, periodic
measurements, Phoenix/Ecto/LiveView built-in events, and LiveDashboard pages
that show a station's pulse rather than a blank VM.

Official reference: [Telemetry and LiveDashboard](https://hexdocs.pm/phoenix_live_dashboard/Phoenix.LiveDashboard.html)

## Examples (13 of 13 bottled)

01. [Kisumu Winam metrics](01-kisumu-winam-metrics/) — available
02. [Mombasa Moi duration](02-mombasa-moi-duration/) — available
03. [Pemba clove counters](03-pemba-clove-counters/) — available
04. [Kilimanjaro Kibo cycle](04-kilimanjaro-kibo-cycle/) — available
05. [Lilongwe lake counts](05-lilongwe-lake-counts/) — available
06. [Lusaka Copperbelt span](06-lusaka-copperbelt-span/) — available
07. [Harare Highveld gauges](07-harare-highveld-gauges/) — available
08. [Gaborone Kalahari throughput](08-gaborone-kalahari-throughput/) — available
09. [Maputo Indian Ocean wait](09-maputo-indian-ocean-wait/) — available
10. [Beira Sofala duration](10-beira-sofala-duration/) — available
11. [Toamasina vanilla gauge](11-toamasina-vanilla-gauge/) — available
12. [Réunion Piton tickets](12-reunion-piton-tickets/) — available
13. [Mayotte lagoon metrics](13-mayotte-lagoon-metrics/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | `:telemetry.execute/3`, `attach/4`, and `detach/1` with duplicate-id errors |
| 02 | `:telemetry.span/3` start/stop pair and shared `telemetry_span_context` |
| 03 | `Telemetry.Metrics.counter/2` and `sum/2` on one weigh event |
| 04 | `attach_many/4` across ascent/descent/summit; failing handlers auto-detach |
| 05 | `last_value/2` gauge with `defstruct` and `String.Chars` |
| 06 | Span exception path with `:kind`, `:reason`, and `:stacktrace` |
| 07 | `summary/2` and `distribution/2` with `tags` and `tag_values` |
| 08 | `telemetry_poller` periodic MFA measurements into a last_value |
| 09 | Phoenix `endpoint` and `router_dispatch` built-in events |
| 10 | Ecto `[:phoenix_multivitamin, :repo, :query]` timings |
| 11 | LiveView `mount` and `handle_event` span events |
| 12 | Custom LiveDashboard `PageBuilder` page via `additional_pages` |
| 13 | Capstone: full metric set, dashboard wiring, handlers sending to `self()` |

```sh
mix test features/23-telemetry-and-livedashboard
mix precommit
```
