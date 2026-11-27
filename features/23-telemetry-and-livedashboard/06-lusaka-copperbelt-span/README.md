# Telemetry and LiveDashboard · 06 · Lusaka Copperbelt span

Ramp lead Mutale stows Copperbelt cargo on an IL-76 at Lusaka International.
`:telemetry.span/3` wraps each load; unstable cargo raises so the library emits
`exception` instead of `stop`, while `start` still fires.

**What it teaches**

- `:telemetry.span/3` emits `EventPrefix ++ [exception]` when the function raises.
- Exception metadata includes `:kind`, `:reason`, and `:stacktrace`.
- The matching `start` event still fires and shares `telemetry_span_context`.

**Files**

| File | Role |
| --- | --- |
| [`copperbelt_span.ex`](copperbelt_span.ex) | Span-wrapped load with exception path |
| [`copperbelt_span_live.ex`](copperbelt_span_live.ex) | Board listening for start/stop/exception |
| [`copperbelt_span_live_test.exs`](copperbelt_span_live_test.exs) | Asserts exception metadata shape |

**Try it**

```sh
mix test features/23-telemetry-and-livedashboard/06-lusaka-copperbelt-span/copperbelt_span_live_test.exs
```
