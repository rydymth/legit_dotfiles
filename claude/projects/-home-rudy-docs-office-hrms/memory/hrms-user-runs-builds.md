---
name: hrms-user-runs-builds
description: "Don't run dotnet build/test or ng build in this repo — the user runs them."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 702dd865-cf10-4a86-941e-255d41f93930
  modified: 2026-10-23T11:09:25.176Z
---

Do not run `dotnet build`, `dotnet test`, or `ng build` in the HRMS repo. Write the code and hand it over; the user builds and tests themselves.

**Why:** They said so directly ("do not build or test leave that to me"). The Angular build is also heavy enough to get OOM-killed on this machine (exit 137 at ~7.8 GB RAM, even with `--max-old-space-size=6144`), so attempting it wastes minutes and can take the session down.

**How to apply:** Verify work by reading the code and by static checks that are cheap and safe (`tsc --noEmit`, grepping template references against component members). State plainly in the summary what was *not* verified, rather than implying a green build. If a build genuinely seems necessary, ask instead of running it.
