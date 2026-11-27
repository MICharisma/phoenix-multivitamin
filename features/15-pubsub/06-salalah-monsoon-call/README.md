# PubSub · 06 · Salalah monsoon call

Hamed follows runway calls on the Salalah apron only while the khareef drizzle is in. Leaving the page needs no cleanup: the subscription dies with the process.

**What it teaches**

- `Phoenix.PubSub.unsubscribe/2` when the desk stops following, with no `terminate/2` cleanup.
- `attach_hook/4` on `:handle_info` replaces a `handle_info/2` callback; `detach_hook/3` drops it.
- A socket-matching event head refuses a second subscribe, which would double every call.

**Files**

| File | Role |
| --- | --- |
| [`monsoon_call_live.ex`](monsoon_call_live.ex) | Follow and unfollow events with an attached `:handle_info` hook |
| [`monsoon_call_live_test.exs`](monsoon_call_live_test.exs) | Following, duplicate subscriptions, dropped messages, and cleanup on exit |

Uses the catalog's `assign_scenario/4` and `<.scenario_identity>`.

**Try it**

From the repository root, after `mix setup`:

```sh
mix phx.server
```

Open
[/features/15-pubsub/06-salalah-monsoon-call](http://localhost:4000/features/15-pubsub/06-salalah-monsoon-call).

Follow the calls, then stop. Calls broadcast while you are not following never reach the page. The tests also show that a duplicate subscribe would deliver every call twice.

Run the scenario tests:

```sh
mix test features/15-pubsub/06-salalah-monsoon-call/monsoon_call_live_test.exs
```
