---
name: hrms-multitenancy-phase-state
description: HRMS multi-tenancy — catalog+key switch is built; migration consolidation deliberately deferred to the team
metadata:
  type: project
---

As of 2026-10-24 the HRMS backend has DB-per-tenant resolution built (catalog `HR_Master.HR_ClientRegistry` + `HR_ClientProductKey`, product key → `tenant_id` JWT claim, `ITenantContext` feeding `HrmsystemContext`/`DapperContext`/`DbConnectionConfig`). Shipped with `MultiTenancy:Enabled = false`, so it is inert until switched on.

Two decisions that are not obvious from the code:

1. **The new .NET 8 backend owns the tenant catalog; legacy SolutionOneWeb adopts it**, not the other way round. Legacy's existing host:port resolution (`DbConnectionFactory.ResolveClientByHost`) is being replaced by a product-key call to `/api/Tenant/Resolve`. Legacy gets **identity only** (ClientCode/DatabaseName) and builds its own connection from its local `clientConnectionTemplate` — both apps share one customer database but keep separate SQL logins, so credentials never cross the wire. Spec written at `HRMS_BackEnd/docs/multi-tenancy-legacy-spec.md`; the user's team implements the legacy side.

2. **Migration consolidation is deferred on purpose** — the user's team is planning it separately. The two migration systems (legacy `App_Data/DbMigrations`, 239 numbered + auto-applied every 2 min per tenant; backend `SqlScripts`, 143 date-named + applied by hand) still both write to the same customer database with nothing reconciling them. `HR_ClientRegistry.SchemaVersion` exists but stays NULL until that work lands — treat NULL as "unknown", never "behind". Do not onboard a second tenant before this is resolved. See [[hrms-two-migration-folders]].

**Why:** multi-tenancy was built in phases at the user's direction, and the deferred piece is the riskier one.

**How to apply:** when touching tenant resolution, don't invent a second catalog or re-point legacy at `HR_Master` directly. When touching migrations, remember both apps write one schema.
