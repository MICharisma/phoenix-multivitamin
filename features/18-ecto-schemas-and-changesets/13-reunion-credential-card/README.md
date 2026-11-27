# Ecto schemas and changesets · 13 · Réunion credential card

Clerk Léa issues a hangar credential for an Air Austral ATR 42-500 at Roland Garros.

**What it teaches**

- Capstone: `cast/3` for form params, `change/2` for a trusted hangar stamp.
- `field :access_token, :string, redact: true` omits the token from `inspect/1`.

**Files**

| File | Role |
| --- | --- |
| [`credential_card.ex`](credential_card.ex) | Schema with redact and stamp_hangar |
| [`credential_card_live.ex`](credential_card_live.ex) | Issues the credential |
| [`credential_card_live_test.exs`](credential_card_live_test.exs) | Hangar RUN1 and redacted inspect |

**Try it**

```sh
mix test features/18-ecto-schemas-and-changesets/13-reunion-credential-card/credential_card_live_test.exs
```
