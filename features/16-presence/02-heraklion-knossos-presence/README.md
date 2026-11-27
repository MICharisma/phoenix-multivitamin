# Presence · 02 · Heraklion Knossos presence

Giorgos plugs in at Heraklion tower before the morning Aegean A321neo wave from Athens. The position board groups every connected controller by the position they are working.

**What it teaches**

- `Presence.list/1` flattened into `{position, controller}` pairs and grouped with `Enum.group_by/3`.
- `Presence.get_by_key/2` answers one question (is the duty supervisor on watch?) without listing the tower.
- `get_by_key/2` returns `[]` for an absent key and a `%{metas: [...]}` map for a present one; a `case` covers both.

**Files**

| File | Role |
| --- | --- |
| [`knossos_presence_live.ex`](knossos_presence_live.ex) | Position board and duty-supervisor check |
| [`knossos_presence_live_test.exs`](knossos_presence_live_test.exs) | Grouping, supervisor arrival and departure, and the `get_by_key/2` shapes |

Uses the feature's shared [`Presence`](../presence.ex) tracker.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?controller=Giorgos&position=tower](http://localhost:4000/features/16-presence/02-heraklion-knossos-presence?controller=Giorgos&position=tower),
then
[?controller=Eleni&position=supervisor](http://localhost:4000/features/16-presence/02-heraklion-knossos-presence?controller=Eleni&position=supervisor)
in a second window. The first window's supervisor line changes when Eleni plugs in.

```sh
mix test features/16-presence/02-heraklion-knossos-presence/knossos_presence_live_test.exs
```
