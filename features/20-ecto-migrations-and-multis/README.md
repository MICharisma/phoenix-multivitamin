# Ecto migrations and multis

change/0, up/down, indexes, and Ecto.Multi so two writes either both land or neither does.

Official reference: [Ecto migrations and multis](https://hexdocs.pm/ecto_sql/Ecto.Migration.html)

## Examples (13 of 13 bottled)

01. [Granada Sierra Nevada migration](01-granada-sierra-nevada-migration/) — available
02. [Beja Alentejo migration](02-beja-alentejo-migration/) — available
03. [Vigo Rías Baixas migration](03-vigo-rias-baixas-migration/) — available
04. [Santiago Compostela vault](04-santiago-compostela-vault/) — available
05. [A Coruña Hercules cabinet](05-a-coruna-hercules-cabinet/) — available
06. [Asturias Picos migration](06-asturias-picos-migration/) — available
07. [Santander Cantabria multi](07-santander-cantabria-multi/) — available
08. [Pamplona San Fermín multi](08-pamplona-san-fermin-multi/) — available
09. [Zaragoza Ebro multi](09-zaragoza-ebro-multi/) — available
10. [Salamanca Plaza Mayor multi](10-salamanca-plaza-mayor-multi/) — available
11. [León Camino multi](11-leon-camino-multi/) — available
12. [Vitoria Basque multi](12-vitoria-basque-multi/) — available
13. [Logroño Rioja handover](13-logrono-rioja-handover/) — available

## What each scenario adds

| Slot | What it adds |
| --- | --- |
| 01 | Reversible `change/0` create table; `with/else` on insert |
| 02 | Explicit `up/0` and `down/0`; `cond` on exported arities |
| 03 | `references/2` and FK index; nested `then/2` and filtered `for` |
| 04 | `unique_index`; SQLite refuses `ALTER TABLE ADD CONSTRAINT` |
| 05 | `alter table` with default; SQLite refuses NOT NULL without DEFAULT |
| 06 | `execute/2` data backfill; `Enum.frequencies_by/2` tallies |
| 07 | `Multi.insert` then `insert`; `Repo.transaction/1` |
| 08 | `Multi.run/3` for a non-schema fee; guarded desk heads |
| 09 | Named steps via `Enum.reduce/3`; `Multi.update/3` |
| 10 | Error short-circuit; inspect failed step and `changes_so_far` |
| 11 | `Multi.merge/2` composing two Multis; `Map.fetch!/2` |
| 12 | Multi inside a context; `@enforce_keys` + `String.Chars` |
| 13 | Capstone: unique migration index and a four-step context Multi |

The consolidated migration that creates these tables lives in
`priv/repo/migrations/20261126210000_create_feature_20_migration_multi_tables.exs`.
Each scenario also keeps a teaching migration module beside its LiveView.

```sh
mix test features/20-ecto-migrations-and-multis
mix precommit
```
