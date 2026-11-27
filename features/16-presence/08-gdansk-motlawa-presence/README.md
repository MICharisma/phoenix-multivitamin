# Presence · 08 · Gdańsk Motława presence

Dispatcher Hanna follows the Wizz Air A321neo turnaround at Gdańsk from the ops desk and often from a second screen. Each dispatcher is listed once, with every screen they have open.

**What it teaches**

- Two tabs tracking the same key produce one presence with two metas, not two people.
- Closing one tab removes only its meta; the dispatcher stays present until the last tab closes.
- A `for` comprehension with two generators and `reduce:` inverts presences into a device index.

**Files**

| File | Role |
| --- | --- |
| [`motlawa_presence_live.ex`](motlawa_presence_live.ex) | Dispatcher list and device index |
| [`motlawa_presence_live_test.exs`](motlawa_presence_live_test.exs) | Two tabs, one closed tab, and separate dispatchers |

Uses the feature's shared [`Presence`](../presence.ex) tracker.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[?dispatcher=Hanna&device=desk](http://localhost:4000/features/16-presence/08-gdansk-motlawa-presence?dispatcher=Hanna&device=desk)
and
[?dispatcher=Hanna&device=tablet](http://localhost:4000/features/16-presence/08-gdansk-motlawa-presence?dispatcher=Hanna&device=tablet).
Hanna shows two screens; close one window and she drops to one.

```sh
mix test features/16-presence/08-gdansk-motlawa-presence/motlawa_presence_live_test.exs
```
