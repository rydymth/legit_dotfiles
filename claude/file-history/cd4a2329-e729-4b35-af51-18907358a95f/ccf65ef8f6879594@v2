---
name: ng-build-blocked-node-version
description: "Angular CLI can't run in this environment (Node too old); use npx tsc / npx ngc to verify frontend changes instead"
metadata:
  node_type: memory
  type: project
  originSessionId: cd4a2329-e729-4b35-af51-18907358a95f
  modified: 2026-10-24T09:30:49.312Z
---

In `FE/`, `npx ng build` and `ng serve` refuse to run: the installed Node is v24.14.1 but the
Angular CLI (v22) demands v22.22.3 / v24.15.0 / v26.0.0. The CLI exits on this version gate before
doing any work, so frontend changes cannot be verified by building the app as of 2026-10-24.

**Why:** it blocks the normal "did my change compile" check and the `/run` skill's browser path.

**How to apply:** verify frontend changes without the CLI —
- `npx tsc -p tsconfig.app.json --noEmit` for TypeScript only.
- `npx ngc -p tsconfig.app.json --outDir <scratchpad>/ngc-out --rootDir ./src` for full AOT
  including template type-checking (catches bad pipe args, unknown bindings).

Always pass `--outDir` **and** `--rootDir ./src` to `ngc`. Without them it emits a `.js` beside
every `.ts` inside `src/`, littering the source tree (~54 files); `--outDir` alone fails with
TS5011. Note `tsconfig.json` does not enable `strictTemplates`, so template checking is basic.

Only `FE/` is a git repo (branch `rudra`); the repo root and `BE/` are not under git here.
`BE/` builds normally with `dotnet build SubscriptionPortal.slnx`.
