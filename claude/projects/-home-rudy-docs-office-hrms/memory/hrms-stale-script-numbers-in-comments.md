---
name: hrms-stale-script-numbers-in-comments
description: HRMS backend code comments cite migration numbers like "script 035"/"script 036" that do not match any real file — they mean SolutionOneWeb 239/240
metadata:
  type: project
---

Backend C# comments (e.g. `HrSalaryHeadMaster.cs`, `HrmsystemContext.cs`, `SalaryHeadModels.cs`, `CtcStructureQueryModels.cs`) refer to "script 035" and "script 036" for the `CTCSection` column and its Lookup Master wording. No such scripts exist; the real files are `HRMS_Payroll/SolutionOneWeb/App_Data/DbMigrations/239_SalaryHeadCtcSection.sql` and `240_CtcSectionLookup.sql`. The numbers appear to be from an earlier draft numbering that was never updated during the port.

**Why:** Following the cited number leads to `034/035/036_*.sql` files about report amount formats and attendance register culture — completely unrelated — which makes a missing-migration diagnosis much slower.

**How to apply:** Treat migration numbers in backend comments as unreliable; grep the column or table name across `*.sql` instead. Related: [[hrms-two-migration-folders]].
