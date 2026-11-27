# Presence · 07 · Kraków Wawel night staff

Wojciech works the night ramp at Kraków while the last Ryanair 737-8200 is de-iced. Opening this page does not put anyone on duty; signing on does.

**What it teaches**

- Tracking starts on a sign-on event rather than on mount, and `Presence.untrack/3` ends it while the tab stays open.
- A second track for the same process, topic, and key returns `{:error, {:already_tracked, pid, topic, key}}`.
- Function heads match the socket's duty state (`{:on_duty, since}` or `:off_duty`) to refuse out-of-order events.

**Files**

| File | Role |
| --- | --- |
| [`wawel_night_staff_live.ex`](wawel_night_staff_live.ex) | Sign-on and sign-off console with the night staff list |
| [`wawel_night_staff_live_test.exs`](wawel_night_staff_live_test.exs) | Sign-on, untrack, repeated sign-on, and out-of-order sign-off |

Uses the feature's shared [`Presence`](../presence.ex) tracker.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?agent=Wojciech](http://localhost:4000/features/16-presence/07-krakow-wawel-night-staff?agent=Wojciech)
and
[?agent=Agnieszka](http://localhost:4000/features/16-presence/07-krakow-wawel-night-staff?agent=Agnieszka).
Sign on and off in one window; the other window's night staff list follows.

```sh
mix test features/16-presence/07-krakow-wawel-night-staff/wawel_night_staff_live_test.exs
```
