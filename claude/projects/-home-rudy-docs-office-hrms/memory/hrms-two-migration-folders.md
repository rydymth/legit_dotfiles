---
name: hrms-two-migration-folders
description: HRMS keeps DB migrations in two unconnected folders; porting SolutionOneWeb work to the backend needs a counterpart script or EF fails with "Invalid column name"
metadata:
  type: project
---

The HRMS workspace has two independent sets of SQL migrations, and they are never synced automatically:

- `HRMS_Payroll/SolutionOneWeb/App_Data/DbMigrations/NNN_*.sql` — numbered, run against the legacy payroll DB by the DbMigrationRunner tool.
- `HRMS_BackEnd/SolutionOne_DataAccessLayer/SqlScripts/Migration_<Thing>_<yyyyMMdd>.sql` — hand-run against the HRMSystem DB that `HrmsystemContext` uses.

**Why:** The CTC Structure / Annexure-I feature was ported from SolutionOneWeb into the .NET backend (commits "Merge niraj_development: the SolutionOneWeb port run"). The entity + context got `CtcSection` → column `CTCSection`, but no backend SqlScripts counterpart to `239_SalaryHeadCtcSection.sql` was written, so on 2026-10-23 *every* `HrSalaryHeadMasters` query — including the unrelated `GetAllSalaryHeadMasters` — died with `Invalid column name 'CTCSection'`. EF selects every mapped column, so one missing column breaks the whole entity, not just the new feature.

**How to apply:** When a SolutionOneWeb port adds or changes a column, check `SqlScripts/` for a matching `Migration_*.sql` before assuming the backend DB has it; if absent, port the numbered script across (keeping the `IF OBJECT_ID / COL_LENGTH ... IS NULL` idempotent guards the folder uses). When an "Invalid column name" error appears from `HrmsystemContext`, grep the column in `HRMS_Payroll/.../DbMigrations` first — the fix is usually a missing backend script, not a code bug. Related: [[hrms-stale-script-numbers-in-comments]].
