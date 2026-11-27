# Telemetry and LiveDashboard · 07 · Harare Highveld gauges

Dispatcher Rudo times Embraer 145 takeoff rolls at Harare International on the
Highveld. `summary/2` and `distribution/2` share the departure event and tag
each roll by runway through a `tag_values` capture.

**What it teaches**

- `summary/2` and `distribution/2` can listen to the same event with tags.
- `tags: [:runway]` plus a `tag_values` function derive runway from metadata.
- `Enum.group_by/2` clusters board departures the same way reporters slice tags.

**Files**

| File | Role |
| --- | --- |
| [`highveld_gauges.ex`](highveld_gauges.ex) | Metric definitions, emit, and runway grouping |
| [`highveld_gauges_live.ex`](highveld_gauges_live.ex) | Board that logs tagged departures |
| [`highveld_gauges_live_test.exs`](highveld_gauges_live_test.exs) | Tag capture, emit probe, and board groups |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/07-harare-highveld-gauges/highveld_gauges_live_test.exs
```
