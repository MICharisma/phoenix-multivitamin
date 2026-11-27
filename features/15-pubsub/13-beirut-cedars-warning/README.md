# PubSub · 13 · Beirut cedars warning

Nour issues runway hazard warnings at Rafic Hariri International. One broadcast reaches the other desks; their acknowledgements come straight back to the issuer.

**What it teaches**

- Capstone: two desks, one `broadcast_from!/4`, no echo on the issuing desk.
- PubSub fans the warning out; each receiving desk replies point-to-point with `send/2`.
- `handle_params/3` picks the desk; streams re-insert a warning when its acknowledgements change.

**Files**

| File | Role |
| --- | --- |
| [`cedars_warning.ex`](cedars_warning.ex) | Enforced-key warning struct, guarded issue, and acknowledgement |
| [`cedars_warning_chars.ex`](cedars_warning_chars.ex) | `String.Chars` for the warning line |
| [`cedars_warning_live.ex`](cedars_warning_live.ex) | Desk switching, fan-out, acknowledgements, and the warning stream |
| [`cedars_warning_live_test.exs`](cedars_warning_live_test.exs) | No echo, acknowledgements, desk switching, and rejected warnings |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/13-beirut-cedars-warning](http://localhost:4000/features/15-pubsub/13-beirut-cedars-warning).

Open the tower in one window and `?desk=apron` in another. Issue a warning from the tower: the apron lists it, and the tower's copy shows "acknowledged by Apron Control" but never its own name.

Run the scenario tests:

```sh
mix test features/15-pubsub/13-beirut-cedars-warning/cedars_warning_live_test.exs
```
