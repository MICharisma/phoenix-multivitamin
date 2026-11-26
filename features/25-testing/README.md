# Testing

ConnTest, LiveViewTest, ChannelCase, SQL sandbox, and assertions that lock the board rather than the markup fashion of the week.

Official reference: [Testing](https://hexdocs.pm/phoenix/testing.html)

## Examples (13 of 13 bottled)

01. [Port Moresby ATIS desk](01-port-moresby-atis-desk/) — available
02. [Cairns reef click board](02-cairns-reef-click-board/) — available
03. [Darwin fuel form](03-darwin-fuel-form/) — available
04. [Broome sector hop](04-broome-sector-hop/) — available
05. [Kalgoorlie wind async](05-kalgoorlie-wind-async/) — available
06. [Hobart frost cell](06-hobart-frost-cell/) — available
07. [Launceston tower channel](07-launceston-tower-channel/) — available
08. [Dunedin fuel ledger](08-dunedin-fuel-ledger/) — available
09. [Christchurch watch session](09-christchurch-watch-session/) — available
10. [Wellington tag range](10-wellington-tag-range/) — available
11. [Rotorua QNH doctest](11-rotorua-qnh-doctest/) — available
12. [Taupō beacon receive](12-taupo-beacon-receive/) — available
13. [Auckland log vault](13-auckland-log-vault/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | ConnCase `get/2`, `html_response/2`, and `json_response/2` |
| 02 | `live/2`, `element/3`, `has_element?/3`, and `render_click/1` |
| 03 | `form/3`, `render_change/1`, and `render_submit/1` |
| 04 | `assert_patch/2` and `follow_redirect/3` |
| 05 | `render_async/1` after `assign_async` |
| 06 | LiveComponent clicks and `send_update/3` |
| 07 | ChannelCase `subscribe_and_join`, `push`, `assert_reply`, `assert_broadcast` |
| 08 | DataCase SQL sandbox plus an `async: true` helper suite |
| 09 | `Phoenix.ConnTest.init_test_session/2` before `live/2` |
| 10 | `describe`, `setup`, `setup_all`, and context tags |
| 11 | ExUnit `doctest` |
| 12 | `assert_receive` with process messaging |
| 13 | Behaviour fake via config, `CaptureLog`, and `@tag :tmp_dir` |
