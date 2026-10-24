---
name: indianization-scope
description: Indianization of the subscription portal — locale/currency shipped 2026-10-24; GST and address fields deliberately deferred
metadata:
  node_type: memory
  type: project
  originSessionId: cd4a2329-e729-4b35-af51-18907358a95f
  modified: 2026-10-24T09:31:04.736Z
---

On 2026-10-24 the user asked to "indianize" the portal and chose the **locale + currency only**
scope, with **display-layer IST** (keep storing UTC, convert only when rendering). Shipped: en-IN
locale + INR currency, IST date/time display, Indian mobile validation.

Deliberately **deferred, not forgotten** — these were found and scoped but left out:
- **GST**: no GSTIN on Tenant, no tax on `Payment`, no place-of-supply (CGST+SGST vs IGST), no
  tax invoice. This is the real commercial gap — Indian B2B customers need a GSTIN on the invoice
  to claim input tax credit.
- **Address**: `Tenant` has no address, state or PIN code; state is what GST place-of-supply
  depends on.
- Both need a DB migration plus business inputs from the user: their GSTIN, home state, whether
  listed prices are tax-inclusive, and the SAC code.

**Why:** picking this up later shouldn't require re-discovering the gaps or re-asking the scope
question.

**How to apply:** if asked to continue Indianization, start from the GST/address list above and
ask for the four business inputs first. See [[ng-build-blocked-node-version]] for how to verify
frontend changes here.
