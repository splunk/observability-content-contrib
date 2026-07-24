# Global admin users (source org)

## Capture source

Splunk On-Call portal → **Settings** → **Organization** → **Users**

Global org admin roles are not listable via the public API. Record them here before source org access ends.

## Global admins

| Username | Display name | Role | Notes |
| --- | --- | --- | --- |
| [TBD] | | Org admin | |

## Team admins (spot-check)

Cross-reference `inventory/team_admins_inventory.json` for API-exported team admin assignments. Verify in the portal that the list is complete.

| Team slug | Team name | Admin usernames (from inventory) | Verified in portal? | Notes |
| --- | --- | --- | --- | --- |
| [TBD] | | | [ ] | |

## Target org plan

Team admins cannot be assigned via apply — configure in the target org UI after migration.

| Source username | Target username | Global admin in target? | Team admin in target? | Notes |
| --- | --- | --- | --- | --- |
| [TBD] | | | | |
