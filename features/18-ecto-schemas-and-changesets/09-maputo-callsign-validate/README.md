# Ecto schemas and changesets · 09 · Maputo callsign validate

Clerk Graça checks a LAM Mozambique Embraer E190 callsign at Maputo International.

**What it teaches**

- `validate_change/3` runs a custom ICAO callsign function.
- Invalid shapes get a domain error message before any write.

**Files**

| File | Role |
| --- | --- |
| [`ramp_card.ex`](ramp_card.ex) | Embedded card with validate_change |
| [`callsign_validate_live.ex`](callsign_validate_live.ex) | Ramp form |
| [`callsign_validate_live_test.exs`](callsign_validate_live_test.exs) | Rejects lam-312 |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/09-maputo-callsign-validate/callsign_validate_live_test.exs
```
