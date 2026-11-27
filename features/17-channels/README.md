# Channels

Phoenix.Channel join, handle_in, handle_out, intercept, and a socket that is not a LiveView.

Official reference: [Channels](https://hexdocs.pm/phoenix/channels.html)

## Examples (13 of 13 bottled)

01. [Alderney Casquets wire](01-alderney-casquets-wire/) — available
02. [Dinard Émeraude talk](02-dinard-emeraude-talk/) — available
03. [Brest Iroise orders](03-brest-iroise-orders/) — available
04. [Pau Pyrenees callback](04-pau-pyrenees-callback/) — available
05. [Perpignan tramontane queue](05-perpignan-tramontane-queue/) — available
06. [Figari Bonifacio isolation](06-figari-bonifacio-isolation/) — available
07. [Pantelleria channel desk](07-pantelleria-channel-desk/) — available
08. [Lampedusa strait talkback](08-lampedusa-strait-talkback/) — available
09. [Kotor bay radio room](09-kotor-bay-radio-room/) — available
10. [Ohrid lake talk](10-ohrid-lake-talk/) — available
11. [Constanța Black Sea wire](11-constanta-black-sea-wire/) — available
12. [Varna Golden Sands talk](12-varna-golden-sands-talk/) — available
13. [Burgas Strandzha orders](13-burgas-strandzha-orders/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | UserSocket connect/3 with a Phoenix.Token, id/1, and disconnect by desk |
| 02 | join/3 authorizing a stand topic against a badge roster |
| 03 | handle_in/3 reply shapes: ok map, error map, bare ok, noreply, stop |
| 04 | broadcast!/3 from the channel to every crew socket |
| 05 | intercept/1 and handle_out/3 rewriting one wind for each departure |
| 06 | reply, push, and broadcast_from! from the same handle_in/3 |
| 07 | after_join push, send_after cadence, and a generation that drops stale ticks |
| 08 | Join assigns from connect + payload, with last_seq replay |
| 09 | terminate/2 on leave, close, and a custom {:stop, ...} hand-over |
| 10 | Exact channel line above a splat, and topics with no channel at all |
| 11 | Binary {:binary, bytes} frames in handle_in and in replies |
| 12 | socket_ref/1 async replies tested through ChannelCase |
| 13 | Capstone: top-level auth_token, intercept redaction, second client, websocket and longpoll |

## Ownership and verification

Each scenario owns its `Phoenix.Socket` and `Phoenix.Channel` modules. The
endpoint only names the thirteen `/features/17-channels/.../socket` mounts.
Catalog LiveViews host a colocated JS client that imports `{Socket}` from
`phoenix`; no `user_socket.js` entry is required in `assets/js/app.js`.

Run the feature scaffolding with:

```sh
mix test features/17-channels
mix precommit
```
