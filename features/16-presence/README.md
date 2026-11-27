# Presence

Phoenix.Presence track, list, diffs, and metas for who is on the watch without inventing a presence table of your own.

Official reference: [Presence](https://hexdocs.pm/phoenix/Phoenix.Presence.html)

## Examples (13 of 13 bottled)

01. [Nicosia Green Line floor](01-nicosia-green-line-floor/) — available
02. [Heraklion Knossos presence](02-heraklion-knossos-presence/) — available
03. [Santorini caldera desk](03-santorini-caldera-desk/) — available
04. [Dubrovnik walls crew](04-dubrovnik-walls-crew/) — available
05. [Split Diocletian watch](05-split-diocletian-watch/) — available
06. [Ljubljana Triple Bridge relief](06-ljubljana-triple-bridge-relief/) — available
07. [Kraków Wawel night staff](07-krakow-wawel-night-staff/) — available
08. [Gdańsk Motława presence](08-gdansk-motlawa-presence/) — available
09. [Riga Daugava operators](09-riga-daugava-operators/) — available
10. [Tallinn Toompea round](10-tallinn-toompea-round/) — available
11. [Helsinki Malmi menders](11-helsinki-malmi-menders/) — available
12. [Turku archipelago crew](12-turku-archipelago-crew/) — available
13. [Visby Gotland radio](13-visby-gotland-radio/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | `Presence.track/4` only on the connected mount; re-read `list/1` on every `presence_diff` |
| 02 | `list/1` grouped by position; `get_by_key/2` for the duty supervisor (`[]` vs `%{metas: …}`) |
| 03 | A presence module with `init/1` and `handle_metas/4` that publishes desk events |
| 04 | Stand as the presence key so many agents' metas merge; enforced-key struct + `String.Chars` |
| 05 | Seed once with `list/1`, then fold each `presence_diff` by `phx_ref` without listing again |
| 06 | `Presence.update/4` with a function; `phx_ref_prev` marks a changed status |
| 07 | Sign-on tracks, sign-off untracks while the tab stays open; `{:already_tracked, …}` |
| 08 | Two tabs, one key, two metas; a `for`/`reduce:` device index |
| 09 | `fetch/2` overlays roster profiles on `list/1` and on leaves in the diff |
| 10 | Streamed presence rows: `get_by_key/2` decides insert vs `stream_delete_by_dom_id/3` |
| 11 | Count people and screens with `Enum.reduce/3`; a shift lead observes without tracking |
| 12 | A killed tab leaves no Presence ghost; the board keeps its own short-lived radio silence |
| 13 | Capstone: track, update, untrack/track, two consoles, `fetch/2`, and a snapshot-diff log |

[Presence](presence.ex) is the shared tracker. Santorini, Riga, and Visby each define their
own tracker in their scenario folder; [PresenceTrackers](presence_trackers.ex) starts every
tracker after PubSub. Tests use [PresenceSync](../../test/support/presence_sync.ex) to drain
the fetch pipeline and flush LiveView mailboxes before assertions.

```sh
mix test features/16-presence
mix precommit
```
