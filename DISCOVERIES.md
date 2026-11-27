# Discoveries

Non-obvious Phoenix behaviors found while bottling this catalog. Every entry
was confirmed by a test in this repository against **Phoenix 1.8.15** and
**LiveView 1.2**. Nothing is written here from the guides alone, and nothing
is written here until a test has shown it.

Each entry has a short title, what happens, why it matters, what to do about
it, and a link to the scenario that shows it.

## Routing and plugs

### assign_new copies a pipeline assign only on the disconnected render

**What happens.** A router pipeline plug assigns `:shift` onto the conn.
The controller tape prints it. A LiveView `assign_new(:shift, fn -> "no
shift from the plug" end)` copies that assign on a disconnected `get/2` of
the hydrant. `socket.assigns` did not already have `:shift`. After `live/2`,
the connected mount runs the fallback. The graveyard shift is gone.

**Why it matters.** Loading a current user, a watch, or a ticket in a
pipeline plug and then `assign_new/3` in the LiveView looks shared. It is
shared only for the static HTML. The LiveView process starts without the
conn and without that assign.

**What to do.** Put shared auth in the session, or load it again in
`mount/3` when `connected?(socket)` is true. Do not treat a pipeline
assign as a socket assign.

**Seen in:** [Changi hydrant tape](features/01-routing-and-plugs/06-changi-hydrant-tape/).

### plug_init_mode :runtime re-runs init/1 on every request in test

**What happens.** `plug KirunaDeicePlug, pads: 2` still turns the
keyword list into a map in `init/1`. This app sets
`config :phoenix, :plug_init_mode, :runtime` in `config/test.exs`. Two
GETs therefore get two different `init/1` timestamps. `Phoenix.plug_init_mode/0`
is `:runtime`. Production defaults to `:compile`.

**Why it matters.** Guides talk about `init/1` as compile-time. Under
`mix test` and `mix phx.server` here, it is per request. A test that
expected one captured timestamp fails. Code that reads `Application.get_env`
in `init/1` will see live config in test and a frozen snapshot in prod.

**What to do.** Keep `init/1` a pure transform of options. Read runtime
config in `call/2`. Do not assert uniqueness of `init/1` in tests unless
you set `:plug_init_mode` to `:compile`.

**Seen in:** [Kiruna de-ice pad](features/01-routing-and-plugs/10-kiruna-deice-pad/).

### redirect/2 without halt/1 still runs the action

**What happens.** `Phoenix.Controller.redirect/2` sends the 302 body.
Without `halt/1`, the next plug — the action — still runs. The leaky briefing
desk then renders and raises `Plug.Conn.AlreadySentError`. The halted desk
never assigns `:plates_opened`.

**Why it matters.** A session plug that "just redirects" looks finished.
The action still opens the drawer and then crashes trying to send a second
response.

**What to do.** Pipe `halt()` after `redirect/2` in a plug. Do not rely on
the redirect having sent.

**Seen in:** [Bergen briefing desk](features/01-routing-and-plugs/11-bergen-briefing-desk/).

## Verified routes

### A nil query value encodes as an empty `key=`, it is not omitted

**What happens.** `~p"/gate?#{[]}"` and `~p"/gate?#{%{}}"` drop the `?`
entirely. `~p"/gate?#{[crew: nil, qnh: "1013"]}"` does not drop `crew`.
It becomes `?crew=&qnh=1013`. `handle_params/3` then sees `"crew" => ""`.
`false` encodes as `"false"`.

**Why it matters.** Passing `nil` looks like "leave this optional key
off". The key is still there, and `value || "none"` will not treat `""`
as missing because an empty string is truthy.

**What to do.** Omit the key from the keyword list or map. Do not pass
`nil` if you wanted the key gone.

**Seen in:** [Gibraltar staff gate](features/02-verified-routes/07-gibraltar-staff-gate/).

### `url(~p)` uses the endpoint `url:` config, including a default port 4000

**What happens.** `config :phoenix_multivitamin, Endpoint, url: [host: "localhost"]`
has no port. `url(~p"/path")` still emits `http://localhost:4000/path`.
The test listener is `http: [port: 4002]` and does not appear. A `%URI{}`
or `put_router_url/2` is what changes the host.

**Why it matters.** A mailer or an `assert` that expected `http://localhost/path`
or `:4002` fails. The generated URL is not the listener the test conn talks to.

**What to do.** Compare against `Endpoint.url() <> path`, or pass a `%URI{}`
/`put_router_url/2` when the public host must differ.

**Seen in:** [Mataveri METAR drum](features/02-verified-routes/08-mataveri-metar-drum/),
[Accra slot relay](features/02-verified-routes/09-accra-slot-relay/).

### A static `~p` never asks the router, and never checks that the file exists

**What happens.** `statics: ~w(assets fonts images favicon.ico robots.txt)`
makes any path whose first segment matches that list call
`Endpoint.static_path/1`. `~p"/images/missing-characteristic.svg"` compiles
with no `no route path` warning. `static_integrity/2` is `nil` until
`mix phx.digest`.

**Why it matters.** A typo in a plate filename looks verified. The 404
is a runtime miss, not a compile warning.

**What to do.** Treat static `~p` as a prefix check. Assert the file is
served, or keep names in one helper.

**Seen in:** [Le Bourget light book](features/02-verified-routes/04-le-bourget-light-book/).

### A list of binaries in one interpolation becomes extra path segments

**What happens.** `~p"/watches/#{watch}"` with a `%IlulissatIceWatch{}` is
one segment. The same sigil with `["dawn", "dusk"]` becomes
`/watches/dawn/dusk`. Compile-time verification substitutes `"1"` for the
interpolation, so it still matches `/watches/:watch`. A slash inside a
binary is `%2F`, not a new segment.

**Why it matters.** A watch list interpolated "to be helpful" compiles
clean and 404s at runtime. The extra segment was never in the router.

**What to do.** Interpolate one `Phoenix.Param` value per dynamic segment.
Do not pass a list unless you mean extra segments.

**Seen in:** [Ilulissat ice logger](features/02-verified-routes/03-ilulissat-ice-logger/),
[Sion alpine fault line](features/02-verified-routes/12-sion-alpine-fault-line/).

### `/features/#{a}/#{b}` does not warn: the stand-in matches the planned catch-all

**What happens.** Verification replaces interpolations with `"1"`.
`~p"/features/#{feature}/#{span}"` is checked as `/features/1/1`, which
matches `live "/features/:feature/:example"`. A retired nested path such
as `/features/02-verified-routes/12-sion-alpine-fault-line/collapsed-ridge`
hidden behind those two dynamics does not warn. A path with enough static
segments (`~p"/features/02-verified-routes/12-sion-alpine-fault-line/collapsed-ridge"`)
does: `no route path ... matches "/.../collapsed-ridge"`.

**Why it matters.** The docs' "dynamic segments skip the warning" is easy
to read as "dynamics are never checked". They are checked, against the
stand-in. A catch-all two segments under `/features` makes a whole family
of paths look verified.

**What to do.** Keep a static prefix long enough to miss the catch-all
when the extra folder is gone. Compile a throwaway module in the test if
you need to show the warning; `mix precommit` treats warnings as errors.

**Seen in:** [Sion alpine fault line](features/02-verified-routes/12-sion-alpine-fault-line/).

## Function components and HEEx

### Passing nil does not restore an attr default

**What happens.** `attr :puff_count, :integer, default: 3` fills puffs when the
caller omits the attr. Passing `puff_count={nil}` writes `nil` onto the assigns
map. The prototype plate then reads "whistle silent", not "3".
`Map.merge(defaults, assigns)` lets an explicit nil win.

**Why it matters.** Clearing a field with `nil` looks like "use the default"
and instead blanks the plate.

**What to do.** Omit the attr, or pass the default value again. Do not pass
nil if you wanted the default.

**Seen in:** [Payerne Roadster flight plate](features/04-function-components-and-heex/01-payerne-roadster-flight-plate/).

### A caller class replaces the global rest default class

**What happens.** `attr :rest, :global, default: %{class: "join-ticket"}`
applies `join-ticket` only when the caller omits `class`. Passing
`class="rush-load"` replaces that default. The two names are not
concatenated. Writing `class="scale-slip"` on the same tag as `{@rest}`
emits a second class attribute; the HTML parser keeps the first, so the
empennage ticket shows `scale-slip` and never `join-ticket`.

**Why it matters.** The docs say the default map is "merged". Map merge
replaces the `class` key. A static class on the same tag hides the rest
class entirely.

**What to do.** Put the class on rest, not also on the tag. Concatenate
caller and default classes yourself if you need both names.

**Seen in:** [Tianjin assembly tickets](features/04-function-components-and-heex/05-tianjin-assembly-tickets/).

### Map.put on component assigns freezes that key after the first render

**What happens.** Inside a function component, `Map.put(assigns, :fired_pass, ...)`
updates the Elixir map but does not mark `__changed__`. `{@fired_pass}`
keeps the first pass even while `{@loft_temp}` updates.
`Phoenix.Component.assign/3` marks the key, so the assign chip's pass
moves. A quiet chip that was never passed `loft_temp` does not recompute
its pass when only the loft changes.

**Why it matters.** A firing pass, timestamp, or generated id written with
`Map.put/3` looks live in the first paint and then never moves.

**What to do.** Use `assign/3`, `assign_new/3`, or `update/3` inside
function components, never `Map.put/3`, if the template should see later
values.

**Seen in:** [Friedrichshafen dope board](features/04-function-components-and-heex/09-friedrichshafen-dope-board/).

### values: does not reject a dynamic assign at runtime

**What happens.** `attr :mark, :atom, values: [:c, :d, :e]`
warns at compile time for a literal outside the list. `mark={@mark}`
with `@mark == :naval` still renders. A direct `gripen_tray/1` call
missing `:mark` raises `KeyError` from `@mark`, not an
`ArgumentError` from `attr/3`. Defaults still apply on that direct call.

**Why it matters.** `values:` looks like a guard. A tray load from a
form or assign will print an unlisted mark without a warning.

**What to do.** Do not treat `values:` as a runtime guard. Check the assign
in Elixir if the tray must refuse an unlisted mark.

**Seen in:** [Linköping Gripen trays](features/04-function-components-and-heex/11-linkoping-gripen-trays/).

### Seeding to_form/2 with the field value makes used_input?/1 true

**What happens.** `used_input?/1` is true when the field is present in form
params without an `_unused_` sibling. `to_form(%{"dispatcher" => "Ngaio"}, as: :permit)`
therefore reports the dispatcher field as used on first paint, before anyone
typed. Starting from `to_form(%{}, as: :permit)` keeps it untouched until
`phx-change` sends the field.

**Why it matters.** Prefilling the dispatcher name to show a default also
unlocks "used" errors and copy on first paint.

**What to do.** Seed `to_form/2` with an empty params map if you need the
untouched state. Put the displayed name in a separate assign.

**Seen in:** [Milford Sound permits](features/04-function-components-and-heex/10-milford-sound-permits/).

## LiveView lifecycle and events

### The disconnected render does not spawn a LiveView process

**What happens.** `get/2` runs `mount/3` and `handle_params/3` inside the
HTTP request. `Phoenix.LiveView.Static.render/3` never starts a LiveView
server. `terminate/2` does not run, even if the LiveView defines it. A
departure desk that records `terminate/2` stays empty after a static GET.

**Why it matters.** Cleanup, unsubscribes, and "who left the board" logs
tied to `terminate/2` only see connected sockets. Counting mounts in
`terminate/2` undercounts the static render.

**What to do.** Treat the disconnected render as a pure function. Arm
clocks, subscribe, and trap exits only when `connected?(socket)` is true. Put
leave-side effects in `terminate/2` of the connected process.

**Seen in:** [Nuuk night board](features/06-liveview-lifecycle-and-events/13-nuuk-night-board/).

### `on_mount` runs twice for `live/2`, once for `get/2`

**What happens.** `on_mount` runs before `mount/3` on the static HTTP
render and again on the connected mount. Those are different processes. A
booth counter incremented in `on_mount` reads 1 after `get/2` and 2 after
`live/2`. Assigns set in `on_mount` are already on the socket when
`mount/3` runs.

**Why it matters.** Starting a timer, opening a port, or incrementing a
global in `on_mount` without checking `connected?/1` doubles up as soon as
a browser connects.

**What to do.** Keep `on_mount` idempotent per process. Share state across
the static and connected mounts only through an external process, and only
when you mean to count both.

**Seen in:** [Rarotonga ATIS watch](features/06-liveview-lifecycle-and-events/12-rarotonga-atis-watch/).

### `send(self())` from `handle_event/3` is applied after that event's render

**What happens.** `send(self(), :strike_sock)` inside `handle_event/3`
queues `handle_info/2` as the next mailbox message. `render_click/1`
returns the HTML from the event callback. That HTML does not yet include
the strike. `:sys.get_state/1` waits until the LiveView is idle; then the
tally is 1.

**Why it matters.** Code that `send(self(), ...)` to "load after paint"
looks broken in a test that only asserts on the `render_click/1` return
value. The follow-up did run; the test sampled too early.

**What to do.** Assert on the event HTML for the click itself. Flush with
`:sys.get_state/1` (or a later `render/1`) before asserting on
`handle_info/2` assigns.

**Seen in:** [Juist windsock book](features/06-liveview-lifecycle-and-events/09-juist-windsock-book/).

### `temporary_assigns` reset the socket, not the last DOM node

**What happens.** A `last_sighting` listed in `temporary_assigns` appears
in the HTML returned by `render_click/1`. After that render, the assign is
reset to the mount value (`nil`) and is not marked changed, so LiveView
does not patch `#last-sighting`. A later event that reads the assign sees
`nil` ("cleared") while the old sighting stays on the page. A go-around
that never touches `last_sighting` leaves that node in place. A regular
assign (`posted_bearings`) keeps every line and does patch.

**Why it matters.** The page still shows a sighting the socket has already
forgotten. Accumulating into a temporary assign loses the prefix. Clearing
the node requires assigning that key again.

**What to do.** Put values you must keep in a regular assign. Use
`temporary_assigns` only for payloads that are safe to forget after the
diff goes out, and re-assign the key when the DOM must change.

**Seen in:** [Ämari range log](features/06-liveview-lifecycle-and-events/10-amari-range-log/).

### `push_event/3` from the disconnected render is discarded

**What happens.** `mount/3` calls `push_event(socket, "arm_stack", %{connected: connected?(socket), ...})` on both renders. After `live/2`,
`assert_push_event` receives one payload, with `connected: true`. The
static payload with `connected: false` never arrives. There is no channel
during `Phoenix.LiveView.Static.render/3`, and the connected mount is a
new socket.

**Why it matters.** A chart, canvas, or stack console that arms itself from
a mount-time push must push again on the connected mount, or the client
hook never sees it.

**What to do.** Push from the connected mount (`if connected?(socket) do`),
or push again from an event the hook sends after `mounted()`.

**Seen in:** [Andøya rocket events](features/06-liveview-lifecycle-and-events/11-andoya-rocket-events/).

### `phx-value-*` payloads are always strings

**What happens.** `phx-value-period="15"` and `phx-value-cells="2"` arrive
in `handle_event/3` as `"15"` and `"2"`. `is_binary(period)` is true. A
click with no `phx-value-*` still fires, with an empty map.

**Why it matters.** `period + 1` and `period == 15` both fail. The card
has to parse, and it has to accept `nil` when the clear button sends
nothing.

**What to do.** Parse in `handle_event/3`. Do not pattern-match integers
out of `phx-value-*`.

**Seen in:** [Kota Kinabalu monsoon card](features/06-liveview-lifecycle-and-events/02-kota-kinabalu-monsoon-card/).

### `phx-key` is a client filter; LiveViewTest does not apply it

**What happens.** The browser compares `phx-key` to `event.key`
case-insensitively and drops a mismatch. `render_keydown/2` does not. A
fog pad with `phx-key="f"` still receives `%{"key" => "x"}` from
LiveViewTest, and `handle_event/3` runs.

**Why it matters.** A round that trusts `phx-key` will post fog when a
test (or a crafted client) sends another key. The filter is not a server
guard.

**What to do.** Pattern-match `"key"` in `handle_event/3` if the action
must only run for that key. Use `phx-key` for the browser, not for
security.

**Seen in:** [Vágar weather round](features/06-liveview-lifecycle-and-events/06-vagar-weather-round/).

### `phx-debounce` and `phx-throttle` are client-side; LiveViewTest does not wait

**What happens.** `phx-debounce="500"`, `phx-debounce="blur"`, and
`phx-throttle="2000"` stay in the markup. `render_change/2` posts radio
copy immediately. Two `render_click/1` calls a millisecond apart both
increment the jet-stream table.

**Why it matters.** A test cannot prove the delay. It can prove the
attribute is present and that the server handles the event when it
arrives. A test that expected "only one click per two seconds" will fail
under LiveViewTest even when the browser throttles.

**What to do.** Assert the attribute and the server-side result. Do not
assert timing in `Phoenix.LiveViewTest`. Time the browser if the delay is
the behavior that matters.

**Seen in:** [St Helena relief board](features/06-liveview-lifecycle-and-events/07-st-helena-relief-board/),
[Keflavik jet-stream table](features/06-liveview-lifecycle-and-events/08-keflavik-jetstream-table/).

### `phx-submit` does not send `_target`

**What happens.** `phx-change` params include `"_target"` naming the field
that moved. `phx-submit` params on the same form do not. A stand clerk
slate that records `had_target?` from `Map.has_key?(params, "_target")`
reads yes on change and no on submit.

**Why it matters.** Code that always pattern-matches `"_target"` will fail
to compile a match on submit, or will skip the assign-stand clause.

**What to do.** Use different event names for change and submit. Read
`_target` only in the change callback.

**Seen in:** [Tivat stand slate](features/06-liveview-lifecycle-and-events/04-tivat-stand-slate/),
[Overberg lamp round](features/06-liveview-lifecycle-and-events/03-overberg-lamp-round/).

## Controllers and JSON

### `json/2` keeps the status `put_status/2` already set

**What happens.** `put_status(:created)` then `json/2` is 201. `put_status(:accepted)`
then `render/3` is 202 with an HTML body. `json/2` alone is 200.

**Why it matters.** `json/2` looks like it might reset the status to OK.
It does not. The body and the status are independent.

**What to do.** Set the status first when 201 or 202 is the point. Do not
expect `json/2` to imply Created.

**Seen in:** [Cusco load sheet](features/03-controllers-and-json/02-cusco-load-sheet/),
[Bariloche Chinook brief](features/03-controllers-and-json/05-bariloche-chinook-brief/).

### `action_fallback` sees tagged tuples; `rescue` sees exceptions

**What happens.** `{:error, :not_found}` from `show/2` hits the fallback
(`via: "fallback"`). `String.to_integer("runway-Q")` raises `ArgumentError`.
The rescued clause answers 422 (`via: "rescue"`). The fallback never runs.

**Why it matters.** A fallback looks like a catch-all error door. It only
runs when the action returns an error tuple, not when Elixir raises.

**What to do.** Return `{:error, reason}` for expected misses. Rescue only
for exceptions you intend to translate.

**Seen in:** [Ulaanbaatar winter NOTAM](features/03-controllers-and-json/04-ulaanbaatar-winter-notam/).

### A JSON 404 is not ErrorHTML's `"Not Found"` page

**What happens.** `put_status(:not_found)` then `json/2` returns
`{"error":"slot_missing",...}`. The resp body is not `"Not Found"` and
not an HTML document.

**Why it matters.** A client that expected the default error page, or a
test that asserted `"Not Found"`, misses the map the action actually sent.

**What to do.** Decide per action whether a miss is ErrorHTML/ErrorJSON or
your own JSON map. `json_response(conn, 404)` reads the map.

**Seen in:** [Malé atoll slot list](features/03-controllers-and-json/09-male-atoll-slot-list/).

### Nested params do not match a flat clause

**What happens.** `create(conn, %{"card" => %{"oat_c" => oat, ...}})`
matches a nested post. The same keys at the top level (`%{"oat_c" => ...}`)
miss that clause and hit the fallback 422 (`nested: false`).

**Why it matters.** A JSON client that posts a flat map looks "almost
right" and never enters the domain clause.

**What to do.** Nest under the domain key the action pattern-matches, or
add a clause that accepts the flat shape.

**Seen in:** [Leh density-altitude card](features/03-controllers-and-json/10-leh-density-altitude-card/).

### `send_resp/3` skips the view and the layout

**What happens.** `put_resp_content_type("text/plain")` then `send_resp/3`
writes the oxygen ticket. The body has no `<html>` and no `catalog-shell`.

**Why it matters.** A later `render/3` in the same action would be
`AlreadySentError`. Tests that look for the catalog chrome will fail even
when the ticket is correct.

**What to do.** Use `send_resp/3` when the body is the ticket. Do not also
render.

**Seen in:** [Lhasa oxygen plan](features/03-controllers-and-json/11-lhasa-oxygen-plan/).

## Core components and layouts

### Overriding a core input class drops the defaults

**What happens.** `<.input class="...border-amber-600...">` emits that
class list. The default `w-full input` string is gone. The field still
posts QNH.

**Why it matters.** A class override looks like "add these utilities".
None of the default input classes are inherited.

**What to do.** When you pass `class`, fully style the input. Keep the
default class if you still want the daisy input look.

**Seen in:** [Eilat desert banner](features/05-core-components-and-layouts/04-eilat-desert-banner/).

### `live_title` suffix belongs to the root layout

**What happens.** The LiveView assigns `page_title` `"Prestwick Atlantic title"`.
The static HTML title is `Prestwick Atlantic title · Phoenix`. The suffix
is in `root.html.heex`, not in the LiveView.

**Why it matters.** A test or a tab title that expected only the assign
misses the suffix. Retitling the assign does not move ` · Phoenix`.

**What to do.** Treat `page_title` as the prefix. Assert the suffix if the
document title is the behavior.

**Seen in:** [Prestwick Atlantic title](features/05-core-components-and-layouts/06-prestwick-atlantic-title/).

## LiveView navigation

### The first `handle_params/3` after `live/2` is still the mount run

**What happens.** `live/2` connects the socket and runs `handle_params/3`.
A counter that starts at 0 still records that run as `:mount`, not
`:patch`. The sahel button is the first `:patch`.

**Why it matters.** A test that treats "already connected" as "already
patched" will expect the wrong via on the first paint.

**What to do.** Count params runs. The first is mount. Only a later
`push_patch` is a patch.

**Seen in:** [Timbuktu dust params](features/07-liveview-navigation/06-timbuktu-dust-params/).

### A query key survives a patch only if the new `~p` still lists it

**What happens.** QNH 1021 is in the URL. Patching the watch with
`~p"...?#{[qnh: socket.assigns.qnh, watch: "evening"]}"` keeps 1021.
Leaving `qnh` out of the keyword list would drop it.

**Why it matters.** "The rest of the query string stays" looks true. It
is only true when the patch builds the query again.

**What to do.** Pass every key you still want. Do not expect the old
query to merge.

**Seen in:** [Gelephu QNH query](features/07-liveview-navigation/09-gelephu-qnh-query/).

## Async assigns

### `assign_async/3` does not start on the disconnected mount

**What happens.** A `get` of the Puerto Natales desk shows the loading
copy and no `32022G34KT`. `live/2` plus `render_async/2` then fills the
wind.

**Why it matters.** The dead HTML looks like "the fetch already ran and
is waiting." The task has not started. There is no result to cache.

**What to do.** Treat the static paint as loading. Assert the value
only after `render_async/2`.

**Seen in:** [Puerto Natales wind fetch](features/08-async-assigns/01-puerto-natales-wind-fetch/).

### `{:error, reason}` lands in `.failed` as `{:error, reason}`

**What happens.** The function returns `{:error, :sounding_timeout}`.
`@sounding.failed` is `{:error, :sounding_timeout}`, not the bare atom.

**Why it matters.** A template or test that matches only
`:sounding_timeout` misses the tagged tuple LiveView actually stored.

**What to do.** Inspect or pattern-match the tagged tuple. Retry by
starting `assign_async` again.

**Seen in:** [Walvis Bay timeout](features/08-async-assigns/12-walvis-bay-timeout/),
[Van icing retry](features/08-async-assigns/04-van-icing-retry/).

### `Process.exit/2` inside `assign_async` takes down the LiveView

**What happens.** The hoist function calls
`Process.exit(self(), :hoist_cable_snap)`. The dead `get` still renders.
`live/2` exits `:hoist_cable_snap`. The assign never becomes `.failed`.

**Why it matters.** Guides say LiveView wraps async errors. A raw exit
of the linked task is not a wrapped failure. It is the LiveView dying.

**What to do.** Return `{:error, reason}` or `raise` if you want a failed
assign. Do not `Process.exit/2` the async process unless you mean to
kill the page.

**Seen in:** [Norilsk hoist exit](features/08-async-assigns/11-norilsk-hoist-exit/).

## Forms and changesets

### `render_change/2` on a form cannot name `phx-auto-recover`

**What happens.** The Ivalo form sets `phx-change="validate_deice"` and
`phx-auto-recover="recover_deice"`.
`form(view, "#deice-card-form", ...) |> render_change("recover_deice")`
raises `FunctionClauseError` in `render_event/3`. The element form of
`render_change` only accepts a value map, and it fires `phx-change`.

**Why it matters.** Auto-recover looks like another change event you can
name from the test. LiveViewTest does not send `phx-auto-recover` that
way.

**What to do.** Call `render_hook(view, "recover_deice", params)` to
exercise the recover clause.

**Seen in:** [Ivalo recover desk](features/09-forms-and-changesets/07-ivalo-recover-desk/).

## LiveComponents

### `update_many/1` is the batch callback; `preload/1` is gone

**What happens.** Three Murmansk QNH cells render in one pass.
`update_many/1` receives the list of `{assigns, socket}` pairs. Each
cell reports batch size 3 and its own QNH. There is no `preload/1`.

**Why it matters.** Older guides still name `preload/1` as the way to
batch a query across sibling components. LiveView 1.2 removed it. A
module that defines `preload/1` never runs that function.

**What to do.** Implement `update_many/1`. Return one socket per pair.
Do not define `preload/1`.

**Seen in:** [Murmansk batch rack](features/11-live-components/06-murmansk-batch-rack/),
[Petropavlovsk capstone rack](features/11-live-components/13-petropavlovsk-capstone-rack/).

### `send_update/3` writes the child; `update_component/3` is gone

**What happens.** Karaganda lifts the cell QNH from 1012 to 1024 with
`send_update(KaragandaQnhCell, id: "qnh-cell", qnh: "1024")`. The parent
assign stays 1012. `update_component/3` is not defined.

**Why it matters.** The old name looks like the current API. It is not.
Calling it fails to compile.

**What to do.** Call `send_update/3` with the module, `id:`, and the
assigns to merge. Leave the parent assign alone if the child owns the
value.

**Seen in:** [Karaganda send update](features/11-live-components/08-karaganda-send-update/).

## JS commands

### `JS.set_attribute/1` encodes as `set_attr`

**What happens.** The Bukhara button calls
`JS.set_attribute({"data-fog", "thick"}, to: "#fog-flag")`. The rendered
`phx-click` JSON names `set_attr`, not `set_attribute`.

**Why it matters.** A test or hook that greps the Elixir function name
misses the command that actually shipped to the browser.

**What to do.** Assert `set_attr` in HTML. Keep `JS.set_attribute/1` in
the template.

**Seen in:** [Bukhara fog flag](features/12-js-commands/06-bukhara-fog-flag/).

### `JS.ignore_attributes/1` encodes as `ignore_attrs`

**What happens.** The Ittoqqortoormiit dialog mounts
`JS.ignore_attributes(["open"], to: "#icing-dialog")`. The rendered
command is `ignore_attrs`. A later tick still leaves the dialog in the
DOM.

**Why it matters.** Same name drift as `set_attr`. The Elixir function
and the client opcode are not spelled the same.

**What to do.** Assert `ignore_attrs` in HTML. Keep
`JS.ignore_attributes/1` in the template.

**Seen in:** [Ittoqqortoormiit ignore](features/12-js-commands/11-ittoqqortoormiit-ignore/).

## PubSub

### Without `handle_info/2`, a message a hook passes on is dropped

**What happens.** The Salalah apron LiveView defines no `handle_info/2`.
Following runway calls attaches a `:handle_info` hook that halts on
`{:runway_call, runway, condition}` and returns `{:cont, socket}` for
anything else. A `{:tide_table, "Raysut", "High water 14:20"}` message
reaches the hook, continues, and disappears. The LiveView keeps running
and the next runway call still lands.

**Why it matters.** A LiveView that defines even one `handle_info/2`
clause crashes on a message no clause matches. Moving that work into a
hook and deleting the callback turns the crash into a silent drop. A
broadcast with a misspelled shape then looks like a broadcast that never
arrived.

**What to do.** Keep a catch-all clause in the hook if you need to see
strays, or define `handle_info/2` with an explicit fallback. Do not rely
on a crash to report an unexpected broadcast.

**Seen in:** [Salalah monsoon call](features/15-pubsub/06-salalah-monsoon-call/).

### `direct_broadcast/4` to your own node arrives after the call returns

**What happens.** With the PG2 adapter, `direct_broadcast/4` sends the
message to the adapter worker registered as
`PhoenixMultivitamin.PubSub.Adapter`, which then dispatches it locally.
With that worker suspended, `direct_broadcast(node(), ...)` returns `:ok`
and nothing has been delivered, while `local_broadcast/3` in the same test
has already delivered. The held message arrives once the worker resumes.
A direct broadcast to `:"riyadh-acc@hijaz"`, a node that is not
connected, also returns `:ok` and delivers nothing.

**Why it matters.** `local_broadcast/3` and `broadcast/3` deliver to local
subscribers before they return. A test that asserts right after a
`direct_broadcast/4` can pass or fail by timing. An `:ok` from a direct
broadcast does not mean the node exists.

**What to do.** Use `local_broadcast/3` for this node. In tests of a
direct broadcast, `assert_receive` or call `:sys.get_state/1` on the
adapter worker before asserting. Check `Node.list/0` if delivery to a
named node matters.

**Seen in:** [Madinah Hijaz hold wire](features/15-pubsub/11-madinah-hijaz-hold-wire/).

### `Endpoint.broadcast/3` needs a string event and does not encode the payload

**What happens.** `Endpoint.broadcast!(topic, "ring", %{gate: "C12",
rung_by: "Maryam"})` reaches a LiveView subscriber as
`%Phoenix.Socket.Broadcast{topic: topic, event: "ring", payload: %{gate:
"C12", rung_by: "Maryam"}}`. The payload's atom keys stay atoms.
`Endpoint.broadcast!(topic, :ring, payload)` raises `FunctionClauseError`
before anything is broadcast.

**Why it matters.** Code that listens to both channels and LiveViews can
expect JSON-shaped string keys. A LiveView receives the Elixir term it
was given. Only the typespec says the event is a string; at runtime an
atom event fails with an error that does not mention the event.

**What to do.** Pass the event as a string, and match the payload with
the keys the publisher used. Use `Phoenix.PubSub.broadcast/3` with your
own message shape when no channel needs the `Broadcast` struct.

**Seen in:** [Doha Pearl floor bell](features/15-pubsub/07-doha-pearl-floor-bell/).
## Presence

### `get_by_key/2` returns `[]` or one fetched presence map, not a list

**What happens.** An absent key returns `[]`. A present key returns the map
`fetch/2` produced for that key — typically `%{metas: [...]}` and any
overlays — not a list of those maps. Heraklion's duty-supervisor check
matches on `%{metas: [%{position: "supervisor"} | _]}`.

**Why it matters.** The hexdocs example shows
`[%{name: "User 1", metas: [...]}]`. Code that pattern-matches a list of
presences will fail against Phoenix 1.8 / phoenix_pubsub 2.4: the fetched
map is returned directly.

**What to do.** Match `[]` for absence and a map with `:metas` for presence.
Keep overlays on that same map in `fetch/2`.

**Seen in:** [Heraklion Knossos presence](features/16-presence/02-heraklion-knossos-presence/).

### Seeding with `list/1` still delivers your own join as a `presence_diff`

**What happens.** Split Approach calls `Presence.list/1` right after
`track/4`, then folds later diffs into the roster. The tracker still
broadcasts a join for that same meta. Without de-duplicating by `phx_ref`,
the controller appears twice.

**Why it matters.** "List once, then apply diffs" looks complete after the
list. The subscribe that made the list useful also delivers the join that
built it.

**What to do.** De-duplicate joins by `phx_ref` when merging into a roster
you already seeded from `list/1`, or skip the list and build only from diffs.

**Seen in:** [Split Diocletian watch](features/16-presence/05-split-diocletian-watch/).

### A killed tracked process leaves no Presence ghost

**What happens.** The tracker links every tracked pid. Killing a crew tablet
produces a leave diff and `get_by_key/2` returns `[]`. Turku's board still
shows the crew member under radio silence because the LiveView keeps its own
short-lived ghost with `Process.send_after/3`.

**Why it matters.** "Ghost presence" is a product concern, not a Presence
leak. Presence has already removed the key; any lingering UI is yours to
schedule and cancel.

**What to do.** Treat Presence leaves as authoritative. Keep application
ghosts in the LiveView (or another process) with an explicit timeout.

**Seen in:** [Turku archipelago crew](features/16-presence/12-turku-archipelago-crew/).
## Channels

### `push`, `reply`, and `broadcast` cannot run inside `join/3`

**What happens.** A Kotor radio-room `join/3` that calls
`broadcast_from!(socket, "operator_on", ...)` raises
`RuntimeError: push/3, reply/2, and broadcast/3 can only be called after
the socket has finished joining.` ChannelTest then sees
`{:error, %{reason: "join crashed"}}`.

**Why it matters.** Announcing a join to the rest of the topic looks like
it belongs in `join/3`. The socket is not marked joined until `join/3`
returns.

**What to do.** `send(self(), :after_join)` from `join/3` and broadcast
from `handle_info(:after_join, socket)`. Put the join reply map in the
`{:ok, reply, socket}` return value instead of pushing it.

**Seen in:** [Kotor bay radio room](features/17-channels/09-kotor-bay-radio-room/),
[Burgas Strandzha orders](features/17-channels/13-burgas-strandzha-orders/).

### `auth_token: true` must be a top-level `socket/3` option

**What happens.** Declaring
`websocket: [auth_token: true, connect_info: [:auth_token, :user_agent]]`
(and the same under `longpoll:`) still leaves the transport's
`:auth_token` option `nil`. `Endpoint.socket/3` copies the *top-level*
`:auth_token` onto each transport with `Keyword.put/3`. When that
top-level key is missing, the copy writes `nil` and overwrites the
nested `true`. LongPoll then never reads `x-phoenix-authtoken`,
`connect_info.auth_token` is `nil`, and a signed watch returns JSON
`{"status": 403}`.

**Why it matters.** Nesting `auth_token: true` next to `connect_info`
looks complete. The header is ignored and every longpoll session is
forbidden.

**What to do.** Set `auth_token: true` on the `socket/3` options
themselves. `load_config/2` then adds `:auth_token` to `connect_info`
automatically; list `:user_agent` (and any other keys) under
`websocket:` / `longpoll:`.

**Seen in:** [Burgas Strandzha orders](features/17-channels/13-burgas-strandzha-orders/).

### LongPoll always answers HTTP 200; the transport status is in the JSON body

**What happens.** A successful new LongPoll session returns HTTP 200 with
`{"status": 410, "token": ...}`. A refused connect returns HTTP 200 with
`{"status": 403}`. `json_response(conn, 410)` raises even when the
transport status is Gone.

**Why it matters.** Asserting the Plug status for Gone or Forbidden
misses the body LongPoll actually uses. Clients and tests that only look
at `conn.status` never see 410 or 403.

**What to do.** Assert `json_response(conn, 200)` and match
`%{"status" => 410, "token" => _}` or `%{"status" => 403}`.

**Seen in:** [Burgas Strandzha orders](features/17-channels/13-burgas-strandzha-orders/).
## Ecto schemas and changesets

### A virtual field survives Repo.insert and is nil after Repo.get

**What happens.** `LusakaHoldCard.changeset/2` puts `remaining_min` with
`put_change/3`. `Repo.insert/1` returns a struct whose `remaining_min` is
`17`. `Repo.get!(LusakaHoldCard, id).remaining_min` is `nil`. The column
was never in the migration.

**Why it matters.** Code that treats the insert return and a later load as
the same shape will read a hold that looks full after reload. The virtual
value lived only in memory on that struct.

**What to do.** Recompute virtual fields after load, or store them if the
page must show them later. Do not expect `Repo.get/2` to keep `virtual: true`.

**Seen in:** [Lusaka hold remaining](features/18-ecto-schemas-and-changesets/05-lusaka-hold-remaining/).

### unique_constraint/3 stays silent during validate

**What happens.** The first `MDG441` insert succeeds. A `phx-change` of the
same callsign after that write does not show `"has already been taken"`.
Only a second `Repo.insert/1` against the unique index adds the error.
`changeset.valid?` is still true on validate for a callsign that already
exists.

**Why it matters.** Live validation looks like it checked uniqueness. It
did not. The desk can look clear until submit races the index.

**What to do.** Treat uniqueness as a write-time check. Show the constraint
error from the failed insert, or query explicitly if the form must warn
earlier.

**Seen in:** [Antananarivo designator](features/18-ecto-schemas-and-changesets/10-antananarivo-designator/).

### prepare_changes/2 does not run on an invalid changeset

**What happens.** A Mauritius ticket with `litres: 0` and
`unit_hint: "us_gallon"` fails `validate_number`. `prepare_changes` never
converts the gallons. No row is written. A valid `1000` US gallon ticket
inserts as `3785` litres.

**Why it matters.** A prepare hook looks like it always normalizes before
the write. Invalid cards skip it entirely, so side effects inside prepare
do not fire on failed validation.

**What to do.** Keep prepare_changes for write-time normalization of valid
data. Do not rely on it to run during validate or on invalid cards.

**Seen in:** [Mauritius fuel prepare](features/18-ecto-schemas-and-changesets/11-mauritius-fuel-prepare/).

### redact: true omits the field from inspect as trailing `...`

**What happens.** `field :access_token, :string, redact: true` stores
`"run-hangar-88"` on the struct. `inspect(card)` does not contain that
string and does not print `**redacted**`. The token is folded into the
trailing `...` of the `#Schema<...>` inspect form.

**Why it matters.** Tests or logs that grep for `**redacted**` miss the
actual redact behavior on current Ecto. The secret is hidden; the marker
string is not.

**What to do.** Assert the secret is absent from `inspect/1`, not that a
literal `**redacted**` appears.

**Seen in:** [Réunion credential card](features/18-ecto-schemas-and-changesets/13-reunion-credential-card/).
## Ecto queries and contexts

### `Repo.stream/2` returns a stream; the raise waits until you reduce it

**What happens.** Outside a transaction, `Repo.stream/2` still returns a
`%Stream{}`. The error does not fire at the call site. Reducing that
stream with `Enum.reduce/3` raises `RuntimeError` with
`"cannot reduce stream outside of transaction"`. The wording is
"cannot reduce stream", not "cannot be invoked".

**Why it matters.** A context that "opens" a stream and hands it to the
caller looks fine in the debugger. The crash lands later, in whoever
consumes the stream, and a regex written from the guides' "must be run
inside a transaction" phrase will miss the real message.

**What to do.** Wrap the stream and its consumption in
`Repo.transaction/2`. Assert on `"cannot reduce stream outside of
transaction"` when testing the failure path.

**Seen in:** [Buenos Aires ledger stream](features/19-ecto-queries-and-contexts/12-buenos-aires-ledger-stream/).

### `Repo.aggregate(:count)` on an empty filtered query returns `0`, not `nil`

**What happens.** `where(occupied == true) |> Repo.aggregate(:count)` on
an empty apron returns `0`. The LiveView can assign that integer
directly. `:avg` on an empty set is the one that returns `nil`.

**Why it matters.** Treating a missing aggregate as "no value" and
writing `count || 0` is harmless for `:count` and wrong for `:avg`.
The empty and zero cases look the same for counts.

**What to do.** For `:count`, assert `0` on an empty table. For `:avg`,
handle `nil` separately.

**Seen in:** [Auckland apron count](features/19-ecto-queries-and-contexts/11-auckland-apron-count/).
## Ecto migrations and multis

### SQLite foreign key errors arrive with a nil constraint name

**What happens.** Inserting a `VigoBayCard` with `vigo_stand_id: -1` hits
the foreign key. The changeset lists
`"vigo_bay_cards_vigo_stand_id_fkey"`, but the adapter reports the
violated constraint as `nil`. `Repo.insert/1` raises
`Ecto.ConstraintError` instead of returning `{:error, changeset}`.

**Why it matters.** `foreign_key_constraint/3` only absorbs errors whose
names match. A nil name never matches, so the LiveView cannot show a
field error the way Postgres would.

**What to do.** Rescue `Ecto.ConstraintError` on SQLite when testing a
missing parent, or look the parent up before insert. Do not expect
`{:error, changeset}` from a bare `foreign_key_constraint/3` alone.

**Seen in:** [Vigo Rías Baixas migration](features/20-ecto-migrations-and-multis/03-vigo-rias-baixas-migration/).

### SQLite refuses `NOT NULL` without `DEFAULT` on a populated table

**What happens.** After a row exists in `coruna_hercules_cabinets`,
`ALTER TABLE … ADD COLUMN forbidden_mark TEXT NOT NULL` returns an
error whose message mentions `NOT NULL` (or that a default is required).
The same alter with `DEFAULT 0` is what the migration used for
`lamp_hours`.

**Why it matters.** An alter that looks fine on an empty table fails the
moment production already has rows. SQLite is stricter here than a
Postgres `ADD COLUMN … NOT NULL` that rewrites with a default in one
step.

**What to do.** When adding a `null: false` column in a migration that
may run against existing rows, pass `default:`. Probe the refusal in
tests before shipping the alter.

**Seen in:** [A Coruña Hercules cabinet](features/20-ecto-migrations-and-multis/05-a-coruna-hercules-cabinet/).

### Failed Multi keeps `changes_so_far` but rolls the database back

**What happens.** Salamanca inserts an order, then fails the line insert
on `qty: 0`. The transaction returns
`{:error, :line, changeset, %{order: order}}`. `order.id` is present in
`changes_so_far`, yet `Repo.get(SalamancaPlazaOrder, order.id)` is `nil`
and the orders table count is `0`.

**Why it matters.** Code that trusts `changes_so_far` as "already
written" will hand out an id that no longer exists. The failed step name
is useful; the structs in `changes_so_far` are not durable.

**What to do.** Treat `changes_so_far` as diagnostic only. After
`{:error, failed_op, failed_value, changes_so_far}`, re-query if you
need to know what remains in the database.

**Seen in:** [Salamanca Plaza Mayor multi](features/20-ecto-migrations-and-multis/10-salamanca-plaza-mayor-multi/).

### SQLite rejects `ALTER TABLE ADD CONSTRAINT`

**What happens.** `create constraint(:santiago_vault_tickets, :litres_positive, check: "litres > 0")`
raises `ArgumentError` with
`"SQLite3 does not support ALTER TABLE ADD CONSTRAINT."` Raw
`ALTER TABLE … ADD CONSTRAINT … CHECK (…)` is refused the same way.
A duplicate `vault_code` still fails only after `Repo.insert/1` hits the
unique index.

**Why it matters.** A migration that works on Postgres fails on this
bottle's SQLite adapter at the constraint step. Putting CHECK in a
separate `create constraint/3` after `create table` is not portable here.

**What to do.** Embed `CHECK` inside `CREATE TABLE` (via `execute/2`),
or enforce the rule in the changeset with `validate_number/3`. Keep
`unique_index/3`; that path works on SQLite.

**Seen in:** [Santiago Compostela vault](features/20-ecto-migrations-and-multis/04-santiago-compostela-vault/).

### Unique constraint stays silent until `Repo.insert`

**What happens.** The first `SCQ-900` insert succeeds. A second submit of
the same vault code fails only when `Repo.insert/1` hits the unique
index. `unique_constraint/3` does not add the error during a cast-only
validate.

**Why it matters.** Live validation can look clear while the migration's
unique index is waiting for the write.

**What to do.** Treat uniqueness as a write-time check. Show the
constraint error from the failed insert.

**Seen in:** [Santiago Compostela vault](features/20-ecto-migrations-and-multis/04-santiago-compostela-vault/).
## Auth and scopes

### `on_mount` `{:halt, redirect(...)}` makes `live/2` return `{:error, {:redirect, ...}}`

**What happens.** Asunción's `ParaguayAuth.on_mount(:require, ...)` returns
`{:halt, redirect(socket, to: "/")}`. A ConnCase `live(conn, path)` without
a session token does not raise. It returns
`{:error, {:redirect, %{to: "/"}}}`.

**Why it matters.** A test that pattern-matches `{:ok, view, html}` fails
with a MatchError and hides the redirect. The guide's "halt the mount"
looks like a hard stop; LiveViewTest surfaces it as a tagged error tuple.

**What to do.** Assert `{:error, {:redirect, %{to: expected}}}` for the
unauthenticated path. Do not wrap `live/2` in `assert_raise`.

**Seen in:** [Asunción Paraguay scope](features/21-auth-and-scopes/06-asuncion-paraguay-scope/),
[Montevideo Rambla scope](features/21-auth-and-scopes/07-montevideo-rambla-scope/).

### An assign_scope plug sets `:current_scope` to `nil`, it does not omit the key

**What happens.** Arequipa's `MistiAssignScope.call/2` with an empty
session assigns `current_scope: nil`. `conn.assigns.current_scope == nil`
is true. The key is present.

**Why it matters.** `Map.get(assigns, :current_scope)` and
`assigns[:current_scope]` both return `nil`, so you cannot tell "guest"
from "plug never ran" with a bare nil check. Templates that do
`@current_scope.clerk` crash on the guest path.

**What to do.** Match on `%Scope{}` versus `nil` before reading fields.
In LiveView, render a locked board when the assign is nil.

**Seen in:** [Arequipa Misti scope](features/21-auth-and-scopes/02-arequipa-misti-scope/).

### A magic-link token becomes `:current_scope`, not `:current_user`

**What happens.** Valdivia's fog link mints a token and redeems it into a
`%LosRiosScope{}`. The LiveView assigns `:current_scope`. The rendered
assign-key list contains `current_scope` and never `current_user`.

**Why it matters.** Older auth examples put the user struct on the
socket. Phoenix 1.8 scopes put a Scope there. Code that reaches for
`@current_user` after a gen.auth-style login finds nothing.

**What to do.** Pass `@current_scope` into contexts. Put clerk or station
fields on the scope struct, not on a parallel user assign.

**Seen in:** [Valdivia Los Ríos scope](features/21-auth-and-scopes/09-valdivia-los-rios-scope/).

### Sudo checks the clock on the scope, not "is signed in"

**What happens.** Concepción stores `biobio_authenticated_at` as an
ISO8601 string in the session. Mount rebuilds `%BiobioScope{authenticated_at: dt}`.
`BiobioSudo.sudo_valid?/1` uses `DateTime.diff/3`. A session that is still
signed in but older than the window fails `unlock_master_plates` until
`renew_session` writes a fresh timestamp.

**Why it matters.** "Require authenticated" and "require sudo" are
different gates. A long-lived session token alone does not satisfy
settings that need a recent credential check.

**What to do.** Keep `authenticated_at` on the scope. Re-check the window
on sensitive events. Renew by writing a new timestamp into the session
(or re-assigning the scope), not by toggling a boolean.

**Seen in:** [Concepción Biobío scope](features/21-auth-and-scopes/10-concepcion-biobio-scope/).

### A scoped logout broadcast reaches every LiveView on that station topic

**What happens.** Iquique's topic is `"iquique:IQQ:nitrate"`. The LiveView
subscribes on connected mount. An external
`NitrateBoards.broadcast_logout(scope)` delivers `{:nitrate_logout, "IQQ"}`
to that process. `handle_info/2` clears the board. A second station's
topic does not receive the message.

**Why it matters.** Broadcasting `"logout"` on a global topic signs
everyone out. Scoping the topic to the station keeps Valentina's hangar
from kicking a clerk on another field.

**What to do.** Subscribe and broadcast on `"app:#{scope.station_id}:…"`.
Handle `{:…_logout, station_id}` by clearing `:current_scope` (or
redirecting), and ignore foreign station ids.

**Seen in:** [Iquique nitrate scope](features/21-auth-and-scopes/11-iquique-nitrate-scope/),
[Cartagena walled scope](features/21-auth-and-scopes/13-cartagena-walled-scope/).

### `:mount_current_scope` continues with nil; `:require_authenticated` redirects

**What happens.** Montevideo's `RamblaAuth.on_mount(:mount_current_scope, …)`
always returns `{:cont, socket}` and may leave `current_scope` as `nil`.
The same module's `:require_authenticated` clause redirects when the
scope is nil. Calling the mount hook alone never redirects.

**Why it matters.** gen.auth exposes both hooks. Putting only
`:mount_current_scope` on a live_session leaves the page public. A
settings LiveView that forgets `:require_authenticated` renders with a
nil scope instead of bouncing to the login.

**What to do.** Use `:mount_current_scope` for public-or-private pages.
Stack or swap to `:require_authenticated` for desks that must have a
scope. Assert both shapes in tests.

**Seen in:** [Montevideo Rambla scope](features/21-auth-and-scopes/07-montevideo-rambla-scope/),
[Córdoba Sierras scope](features/21-auth-and-scopes/08-cordoba-ar-sierras-scope/).
## Mailers with Swoosh

### `Mailer.deliver/2` with `adapter: Local` bypasses the Test mailbox

**What happens.** Test config sets
`adapter: Swoosh.Adapters.Test`. Calling
`Mailer.deliver(email, adapter: Swoosh.Adapters.Local)` still stores the
email in `Swoosh.Adapters.Local.Storage.Memory` and returns a Message-ID.
`assert_email_sent` / `refute_email_sent` see nothing, because the Test
adapter never received the mail.

**Why it matters.** A scenario that "delivered" for `/dev/mailbox` looks
like a silent failure under `Swoosh.TestAssertions`. The Local override and
the Test mailbox are separate channels.

**What to do.** Assert against `Memory.all/0` (or the returned Message-ID)
when the call overrides to Local. Use `assert_email_sent` only for the
configured Test adapter path.

**Seen in:** [Salvador Pelourinho mailer](features/22-mailers-with-swoosh/04-salvador-pelourinho-mailer/),
[Lalibela rock mailer](features/22-mailers-with-swoosh/13-lalibela-rock-mailer/).

### `deliver_many/1` posts `{:emails, list}`, not `{:email, one}`

**What happens.** `Mailer.deliver_many(emails)` through the Test adapter
sends one `{:emails, list}` message. `assert_email_sent(subject: ...)`
times out. `assert_emails_sent([%{subject: ...}, ...])` matches.

**Why it matters.** A roster send that looks identical to three single
delivers fails the singular assertion even though the emails left.

**What to do.** Use `assert_emails_sent/1` (and `refute_emails_sent/0`) for
`deliver_many`. Keep `assert_email_sent` for `deliver/1`.

**Seen in:** [Kumasi garden mailer](features/22-mailers-with-swoosh/12-kumasi-garden-mailer/).

### Missing `from` returns `{:error, :from_not_set}` before the adapter runs

**What happens.** An email built with `to`, `subject`, and `text_body` but
no `from` makes `Mailer.deliver/1` return `{:error, :from_not_set}`. The
Test adapter receives nothing; `refute_email_sent/0` passes.

**Why it matters.** The failure looks like an adapter outage. It is a
Mailer sanity check. Custom adapters never see the email.

**What to do.** Pattern-match `{:error, :from_not_set}` separately from
adapter errors. Set `from/2` before deliver.

**Seen in:** [Luxor Nile mailer](features/22-mailers-with-swoosh/10-luxor-nile-mailer/).

### `attachment/2` prepends; the last pipe step is first in the list

**What happens.** Piping two CSV cook cards through `attachment/2` yields
`attachments` ordered `[nose-gear.csv, aft-spar.csv]` when the reduce
applied aft-spar first. Each call prepends.

**Why it matters.** Asserting `Enum.map(attachments, & &1.filename) ==
input_order` fails even though both files are present.

**What to do.** Assert with sorted names, membership, or the reverse of
pipe order. Do not assume append.

**Seen in:** [Curitiba wire mailer](features/22-mailers-with-swoosh/06-curitiba-wire-mailer/).
## Telemetry and LiveDashboard

### Duplicate `:telemetry.attach/4` ids return `{:error, :already_exists}`

**What happens.** Attaching a Winam ferry handler under the same handler id a
second time returns `{:error, :already_exists}`. It does not raise. A later
`:telemetry.detach/1` after a successful detach returns `{:error, :not_found}`.

**Why it matters.** Retrying attach in `mount/3` looks harmless. The second
attempt leaves the first handler in place and the board may think attach
failed when the listener is already live.

**What to do.** Treat `{:error, :already_exists}` as a branch. Detach in
`terminate/2`. Do not assume attach always returns `:ok`.

**Seen in:** [Kisumu Winam metrics](features/23-telemetry-and-livedashboard/01-kisumu-winam-metrics/).

### A raising telemetry handler is auto-detached

**What happens.** A Kibo handler attached with `attach_many/4` raises on the
summit event. Telemetry detaches that handler id from every event in the
list. Later ascent and descent emits are silent. A follow-up `detach/1`
returns `{:error, :not_found}`.

**Why it matters.** One bad clause for one event removes the whole
`attach_many` subscription. The board looks quiet with no compile error.

**What to do.** Keep handlers total and side-effect only. Rescue inside the
handler if you must stay attached. Confirm detach results in tests.

**Seen in:** [Kilimanjaro Kibo cycle](features/23-telemetry-and-livedashboard/04-kilimanjaro-kibo-cycle/).

### `:telemetry.span/3` exception events replace stop

**What happens.** An unstable Copperbelt load raises inside the span
function. Handlers see `EventPrefix ++ [start]` then
`EventPrefix ++ [exception]` with `:kind`, `:reason`, and `:stacktrace`.
No stop event fires for that span. Telemetry re-raises after emitting
exception so an outer `rescue` can still map the failure.

**Why it matters.** Counting stop events under-counts failed work. Pairing
start to stop by `telemetry_span_context` misses exceptions entirely.

**What to do.** Attach to start, stop, and exception. Match contexts across
the three. Treat exception as the terminal event for that span.

**Seen in:** [Lusaka Copperbelt span](features/23-telemetry-and-livedashboard/06-lusaka-copperbelt-span/).

### LiveView mount telemetry fires twice under `live/2`

**What happens.** Attaching to `[:phoenix, :live_view, :mount, :start]` and
running `live/2` for the Toamasina board yields two start events and two
stop events: the disconnected mount, then the connected mount.

**Why it matters.** A test that expects one mount span flakes or under-counts.
Production traffic that only hits the connected path still differs from
LiveViewTest.

**What to do.** Assert a count of two under `live/2`, or filter on
`connected?(socket)` metadata if you need a single path.

**Seen in:** [Toamasina vanilla gauge](features/23-telemetry-and-livedashboard/11-toamasina-vanilla-gauge/).

### LiveDashboard `init/1` receives `[]` from `additional_pages`

**What happens.** `additional_pages: [piton_tickets: PageModule]` calls
`init([])`. A clause `init(tickets) when is_list(tickets)` treated that
empty list as an empty ticket board. `menu_link/2` returned
`{:disabled, _}` and `live/2` on `/dev/dashboard/piton_tickets` redirected
to `/dev/dashboard/home`.

**Why it matters.** The custom page looks registered in the router and still
never opens. Empty-list opts are not domain data.

**What to do.** Read `Keyword.get(opts, :tickets, defaults)` in `init/1`.
Do not pattern-match a bare list as your session payload.

**Seen in:** [Réunion Piton tickets](features/23-telemetry-and-livedashboard/12-reunion-piton-tickets/).
## Gettext translations

### Missing interpolation bindings leave `%{key}` in the msgstr and log; they do not raise

**What happens.** `gettext("Flight %{flight} to stand %{stand}", %{})`
returns the Arabic msgstr with `%{flight}` and `%{stand}` still in the
string. Logger emits `missing Gettext bindings: [:flight, :stand]`.
There is no `KeyError`.

**Why it matters.** Concatenation habits suggest a missing key should
crash the request. Gettext soft-fails so a forgotten binding ships as a
half-translated line with a log line, not a 500.

**What to do.** Pass every `%{name}` as a binding. Treat the log as a
defect, not as optional noise. Do not rescue `KeyError` around gettext.

**Seen in:** [Cairo EgyptAir bindings](features/24-gettext-translations/09-cairo-egyptair-bindings/).

### An empty `msgstr ""` falls back to the msgid

**What happens.** The Kraków NOTAM msgid has `msgstr ""` in the Polish
`.po`. `Gettext.gettext/2` returns the English msgid
`"Snow NOTAM pending review"`, not an empty string. A filled msgstr
returns the Polish line.

**Why it matters.** An empty msgstr looks like "translate to blank".
Gettext treats it as untranslated and falls back to the msgid, so the
board still shows English.

**What to do.** Leave msgstr empty only while a translation is pending.
Assert fallback by comparing the result to the msgid, not to `""`.

**Seen in:** [Kraków fallback msgid](features/24-gettext-translations/11-krakow-fallback-msgid/).

### `put_locale/2` in a Plug does not reach the LiveView process

**What happens.** A router locale plug calls `Gettext.put_locale/2` in
the HTTP request process. That stamps the controller action. The
LiveView that later mounts is another process, so its gettext calls use
the default locale unless `on_mount` or `mount` puts the locale again.
`Gettext.with_locale/3` restores the previous locale when its function
returns, still only for the process that called it.

**Why it matters.** Copying a controller locale plug onto a LiveView
route looks shared. The connected LiveView never sees that process
dictionary.

**What to do.** Put locale in `on_mount` or `mount`/`handle_params` for
LiveViews. Keep Plug `put_locale` for controller actions. Use
`with_locale/3` when a brief must borrow another language without
leaving the process there.

**Seen in:** [Lyon Accept-Language](features/24-gettext-translations/05-lyon-accept-language/),
[Tunis on_mount locale](features/24-gettext-translations/12-tunis-on-mount-locale/),
[Riyadh with_locale](features/24-gettext-translations/10-riyadh-with-locale/).
## Testing

### `render_async/1` is what waits; the first `live/2` HTML may still be loading

**What happens.** Kalgoorlie starts `assign_async` only when `connected?(socket)`
is true. A disconnected `get/2` keeps the static Goldfields line and never
shows `27018G26KT`. After `live/2`, `render_async(view)` is what waits for
the wind value. There is no `Process.sleep/1`.

**Why it matters.** Asserting the wind on the first `live/2` HTML races the
task. The dead render looks like a failed fetch when it was never started.

**What to do.** Assert the static copy on `get/2`. Call `render_async/1`
before locking the async value.

**Seen in:** [Kalgoorlie wind async](features/25-testing/05-kalgoorlie-wind-async/).

### SQLite DataCase stays `async: false` for Repo writes

**What happens.** Dunedin posts through the ledger under
`use PhoenixMultivitamin.DataCase, async: false`. A second test in the same
module sees an empty table — the sandbox rolled the first post back. An
`async: true` DataCase that still opens the sandbox can hit
`database is locked` on SQLite. Pure in-memory totals use a separate
`ExUnit.Case, async: true` module with no sandbox.

**Why it matters.** Copying a Postgres `async: true` DataCase onto SQLite
looks fine until two owners write at once.

**What to do.** Keep Repo examples on `async: false`. Put CPU-only helpers
on a plain async ExUnit case.

**Seen in:** [Dunedin fuel ledger](features/25-testing/08-dunedin-fuel-ledger/).

### Socket `connect/2` returns the atom `:error`, not `{:error, reason}`

**What happens.** `connect(LauncestonTowerSocket, %{"desk" => "east"})`
returns `:error`. A bad runway after a good connect returns
`{:error, %{reason: "unknown_runway"}}` from `subscribe_and_join/3`.

**Why it matters.** Pattern-matching `{:error, _}` on `connect/2` fails.
The socket refused the desk before a channel existed.

**What to do.** Match `:error` on connect. Match `{:error, map}` on join.

**Seen in:** [Launceston tower channel](features/25-testing/07-launceston-tower-channel/).

### `CaptureLog` is empty for `Logger.info` when test logger level is `:warning`

**What happens.** `config/test.exs` sets `config :logger, level: :warning`.
Archiving NZAA logs an info line. `capture_log/1` returns `""`. Refusing
NZWN logs a warning; `capture_log/1` then contains
`Waitematā vault refused NZWN`.

**Why it matters.** Asserting on an info message under the default test
logger level fails with an empty string, not a missing substring.

**What to do.** Log warnings (or errors) for assertions, or raise the
capture level. Do not assert on info lines under `:warning`.

**Seen in:** [Auckland log vault](features/25-testing/13-auckland-log-vault/).
