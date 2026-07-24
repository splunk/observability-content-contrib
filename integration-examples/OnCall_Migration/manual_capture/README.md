# Manual capture

Splunk On-Call has no public API for listing integrations, global user permissions, or org SSO settings. Capture these from the portal and your identity provider after discovery completes.

See [docs/MIGRATION_GUIDE.md](../docs/MIGRATION_GUIDE.md) (Phase 2) for workflow context.

## Security

- **Never commit secrets**: API keys, webhook signatures, integration credentials, SAML private keys, or full metadata XML with embedded secrets.
- Store secrets in a vault; *record only vault paths in capture files.*
- Filled integration JSON files (`integrations/*.json` except `integration.example.json`) are **gitignored** by design.



## Checklist



### 1. Integrations

**Source:** Splunk On-Call portal → **Integrations**

For each enabled integration tile:

1. Copy the example schema:
  ```bash
   cp integrations/integration.example.json integrations/<integration-name>.json
  ```
2. Fill in non-secret settings (name, type, enabled state, portal path, configuration fields visible in the UI).
3. Put credentials in your vault; set `secrets_vault_reference` to the vault path only.
4. Cross-reference `inventory/alert_rules_inventory.json` and `inventory/outbound_webhooks_inventory.json` for related automation (do not duplicate secrets from those files).
5. Add an entry to the `integrations` array in [capture_status.json](capture_status.json).

Common integration types: ServiceNow, Slack, REST/Generic, outbound webhooks.

### 2. User permissions

**Source:** Splunk On-Call portal → **Settings** → **Organization** → **Users**

Fill in [user_permissions/admin_users.md](user_permissions/admin_users.md):

- Global org admins (not exportable via API)
- Team admins — spot-check against `inventory/team_admins_inventory.json`
- Target-org plan (who should be admin after migration)

**Note:** Team admin assignment has no public POST API; configure admins in the target org UI after apply.

### 3. SSO settings

**Source:** Identity provider admin console (not the Splunk On-Call portal)

Fill in [sso/idp_config.md](sso/idp_config.md):

- IdP application settings (entity ID, ACS URL, attribute mappings)
- Splunk On-Call standard constants (below)
- Vault path for SAML metadata — do not paste private keys or full metadata XML here


| Setting         | Value                                              |
| --------------- | -------------------------------------------------- |
| ACS / Reply URL | `https://sso.victorops.com/sp/ACS.saml2`           |
| Entity ID       | `victorops.com`                                    |
| Relay state     | `https://portal.victorops.com/auth/sso/{org_slug}` |


SSO backend configuration in Splunk On-Call is coordinated with Splunk support; document IdP-side settings only.

### 4. Update status tracker

Edit [capture_status.json](capture_status.json):

- Set each category to `pending`, `in_progress`, or `complete`
- Set `updated_at` when you finish a review pass
- Mark `integrations` entries as you add each JSON file



## Validation

Before source org access ends:

- [ ] Every enabled integration tile has a JSON file in `integrations/` (local; gitignored)
- [ ] Global admins recorded in `user_permissions/admin_users.md`
- [ ] Team admins spot-checked against API inventory
- [ ] IdP SSO documented with correct relay state for org slug
- [ ] `capture_status.json` categories all marked `complete`
- [ ] `manual_capture/` backed up off-machine alongside `inventory/`



## Related documentation

- [docs/MIGRATION_GUIDE.md](../docs/MIGRATION_GUIDE.md) — full migration workflow
- [docs/VALIDATION_REPORT.md](../docs/VALIDATION_REPORT.md) — post-discovery validation template
- [docs/TROUBLESHOOTING.md](../docs/TROUBLESHOOTING.md) — apply failures and edge cases

