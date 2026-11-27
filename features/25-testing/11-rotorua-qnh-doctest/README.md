# Testing · 11 · Rotorua QNH doctest

Clerk Aroha parses steam-field QNH for a Squirrel AS350 at Rotorua. The
module's `@doc` examples are the suite: `doctest PhoenixMultivitamin.RotoruaQnh`
runs every `iex>` line as an assertion.

**What it teaches**

- `doctest Module` turns documentation examples into ExUnit cases.
- Examples must match the return value exactly, including tuples and atoms.
- Guards on `parse/1` and `label/1` keep invalid QNH out of the board.
- A separate test covers a `FunctionClauseError` that does not belong in a
  doctest.

**Files**

| File | Role |
| --- | --- |
| [`qnh.ex`](qnh.ex) | Module with @doc doctests |
| [`qnh_doctest_live.ex`](qnh_doctest_live.ex) | Catalog form |
| [`qnh_test.exs`](qnh_test.exs) | `doctest` plus a clause error |
| [`qnh_doctest_live_test.exs`](qnh_doctest_live_test.exs) | Catalog smoke test |

**Try it**

```sh
mix phx.server
```

Open
[/features/25-testing/11-rotorua-qnh-doctest](http://localhost:4000/features/25-testing/11-rotorua-qnh-doctest).

```sh
mix test features/25-testing/11-rotorua-qnh-doctest/qnh_test.exs
```
