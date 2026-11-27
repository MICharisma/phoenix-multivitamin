# PubSub

Phoenix.PubSub subscribe, broadcast, broadcast_from, and topics that keep two watches on the same board without sharing a socket.

Official reference: [Phoenix.PubSub](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html)

## Examples (13 of 13 bottled)

01. [Baku Caspian handover](01-baku-caspian-handover/) — available
02. [Tbilisi Mtatsminda relief](02-tbilisi-mtatsminda-relief/) — available
03. [Yerevan Ararat relay](03-yerevan-ararat-relay/) — available
04. [Tehran Alborz wire](04-tehran-alborz-wire/) — available
05. [Muscat khareef alert](05-muscat-khareef-alert/) — available
06. [Salalah monsoon call](06-salalah-monsoon-call/) — available
07. [Doha Pearl floor bell](07-doha-pearl-floor-bell/) — available
08. [Abu Dhabi Yas stand call](08-abu-dhabi-yas-stand-call/) — available
09. [Sharjah creek hail](09-sharjah-creek-hail/) — available
10. [Jeddah Red Sea board](10-jeddah-red-sea-board/) — available
11. [Madinah Hijaz hold wire](11-madinah-hijaz-hold-wire/) — available
12. [Amman Nabatean hail](12-amman-nabatean-hail/) — available
13. [Beirut cedars warning](13-beirut-cedars-warning/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | subscribe/2 only in the connected mount; the posting desk updates from its own broadcast |
| 02 | broadcast/3 from an event on a publish-only desk; an enforced-key struct is the message |
| 03 | broadcast_from/4 with self(); the sender logs locally and skips its echo |
| 04 | Topics named for each station, subscribed in a comprehension and decoded with binary patterns |
| 05 | handle_info/2 clauses for broadcasts and timers, guarded by level and alert serial |
| 06 | unsubscribe/2 with a detachable :handle_info hook; no terminate/2 cleanup |
| 07 | Endpoint.subscribe/1 and broadcast!/3 deliver %Phoenix.Socket.Broadcast{}; the adapter lives in the child spec |
| 08 | A routed LiveView and its live_render/3 children share one topic in both directions |
| 09 | A context broadcasts after Repo.insert/1; a stream fills from handle_info/2 |
| 10 | Broadcast the change, not the record; :erlang.external_size/1 measures the difference |
| 11 | broadcast/3, local_broadcast/3, and direct_broadcast/4 with node_name/1 on a single node |
| 12 | One station topic with a Phoenix.PubSub.Sender per watch instead of a topic per watch |
| 13 | Capstone: two desks, one broadcast_from!/4, and acknowledgements sent straight back |

Every scenario uses the application's `PhoenixMultivitamin.PubSub` server with the
default `Phoenix.PubSub.PG2` adapter on a single node. Each scenario owns its topic
names. Sharjah adds the `sharjah_creek_hails` table through a migration in
`priv/repo/migrations/`.

Tests subscribe the test process to a scenario's topic to observe broadcasts, and
open several `live/2` connections to stand in for separate desks.

```sh
mix test features/15-pubsub
mix precommit
```
