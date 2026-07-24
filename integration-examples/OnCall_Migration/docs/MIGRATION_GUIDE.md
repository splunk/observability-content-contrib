# Splunk On-Call Migration Guide

Deep reference for exporting and migrating Splunk On-Call (VictorOps) configuration. For installation, credentials, and step-by-step commands, start with [`README.md`](../README.md). After discovery, optionally record results using [`VALIDATION_REPORT.md`](VALIDATION_REPORT.md). For apply failures and edge cases, see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

---

## Objective

Build a **complete, durable configuration snapshot** of a Splunk On-Call org:

1. **API discovery** — export all public-API-discoverable config to JSON
2. **Manual capture** — document gaps the API cannot list (integrations, global permissions, SSO)
3. **Primary apply** — provision core target-org config from inventory + remapping via `apply.py`
4. **Deferred user settings** — contact methods and paging policies via `apply_contact_methods_and_policies.py` (after users exist in target)

Terraform was evaluated and rejected for the apply step: the `splunk/victorops` provider doesn't cover all resources and is inconsistently maintained. Target-org provisioning is implemented in `apply.py` and the deferred script instead.

---

## Quick reference

### Migration workflow

| Step | Action | Command | Output / note |
| :--- | :--- | :--- | :--- |
| 1 | Discovery | `python3 discovery.py` | `inventory/*.json`, `inventory_summary.md` (~30–40 min for large orgs). Optional partial export: `--teams` / `--teams-file` — see [Scoped discovery](#scoped-discovery-partial-export) below. |
| 2 | Validation | `python3 validate_inventory.py` | Exit 0/1 — consistency checks |
| 3 | Remapping | `python3 generate_remapping.py` | `inventory/remapping.json` — edit manually; set `null` to skip |
| 4 | Pre-flight | `python3 validate_apply.py` | Exit 0/1 — remapping integrity |
| 5 | Dry run | `python3 apply.py` | No writes to target org |
| 6 | Apply | `python3 apply.py --apply` | `inventory/apply_report.json` |
| 7 | Deferred user settings | `python3 apply_contact_methods_and_policies.py` then `--apply` | Contact methods + paging steps (dry-run default; run after step 6). See [Phase 3b](#phase-3b-deferred-user-settings). |

**uv:** With a project `.venv`, prefix commands with `uv run` (e.g. `uv run python3 discovery.py`). Without a venv, use `uv run --with requests python3 <script>.py` for any pipeline script.

### Safety and important notes

- **Dry run first:** `python3 apply.py` (no `--apply`) simulates the migration and writes `inventory/apply_report.json` without changing the target org. Review that report before you run with `--apply`. After primary apply, run `python3 apply_contact_methods_and_policies.py` (dry-run default) before `--apply` for contact methods and paging policies — the deferred script logs planned POSTs but does not write a separate report file.
- **Escalation policies cannot be edited later:** Once created in the target org, policy steps and routing cannot be changed through the API. Double-check `inventory/remapping.json` and run `python3 validate_apply.py` before applying.
- **Re-running apply:** A second run is mostly safe for resources that already exist — users, teams, members, rotations, and escalation policies are skipped when found. Routing keys and alert rules are posted again and may fail or duplicate if they already exist. A policy created with wrong steps cannot be fixed by re-applying; fix it in the target UI or delete and recreate the policy manually, then adjust remapping if needed. Re-running `apply_contact_methods_and_policies.py --apply` skips existing emails, phones, and matching paging steps via GET preflight; duplicate contact POSTs otherwise return HTTP 500 from the API.
- **Overwrites:** Re-running `generate_remapping.py` overwrites `inventory/remapping.json`. Back up manual edits first.
- **Troubleshooting:** For apply failures and known edge cases (cascade failures, user 409 conflicts, non-member rotation refs, deferring users, idempotency), see [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

### Scope

**Included in automated apply:** `users`, `teams`, `members`, `rotations`, `escalation_policies`, `routing_keys`, `alert_rules`

**Applied by deferred script (`apply_contact_methods_and_policies.py`, after primary apply):** `contact_methods`, `paging_policies`

**Deferred:** `outbound_webhooks`, `active_overrides`, `integrations`, `SSO`

**Manual after apply:** Team admins (no public POST API)

---

## Repository layout

```
OnCall_Migration/
├── README.md
├── requirements.txt
├── .env.example                  # copy to .env (gitignored)
├── discovery.py                  # step 1 — export source org
├── validate_inventory.py         # step 2
├── generate_remapping.py         # step 3
├── validate_apply.py             # step 4
├── apply.py                      # steps 5–6 (dry-run / --apply)
├── apply_contact_methods_and_policies.py  # step 7 — deferred user settings
├── utils/
│   ├── env_loader.py
│   ├── io.py
│   ├── cli.py
│   ├── http_client.py
│   ├── rate_limiter.py
│   ├── exceptions.py
│   ├── migration_types.py
│   ├── summary_reporter.py
│   └── team_scope.py
├── docs/
│   ├── MIGRATION_GUIDE.md        # this file
│   ├── VALIDATION_REPORT.md      # post-discovery template
│   └── TROUBLESHOOTING.md        # apply failures and edge cases
├── tests/
│   ├── test_discovery.py
│   ├── test_apply.py
│   └── …                         # other test_*.py modules
├── inventory/                    # gitignored — API export + remapping
│   ├── *_inventory.json
│   ├── discovery_metadata.json
│   ├── inventory_summary.md
│   ├── remapping.json
│   └── apply_report.json         # written after apply
├── manual_capture/               # templates tracked; integration JSON captures gitignored
│   ├── README.md
│   ├── capture_status.json
│   ├── integrations/
│   │   └── integration.example.json
│   ├── user_permissions/
│   └── sso/
└── discovery_run.log             # gitignored — discovery HTTP log
```

| Path | Purpose |
| :--- | :--- |
| `discovery.py` | Read-only exporter. Four-phase pipeline; threaded per-entity fetch with shared 2 req/sec limit |
| `validate_inventory.py` | Post-discovery consistency checks (no API) |
| `generate_remapping.py` | Build `remapping.json` template from inventory |
| `validate_apply.py` | Pre-flight remapping + relational integrity checks |
| `apply.py` | Target-org provisioning (dry-run default; `--apply` to write) |
| `apply_contact_methods_and_policies.py` | Deferred user contact methods and paging policies (dry-run default; run after `apply.py --apply`) |
| `utils/env_loader.py` | Project-root `.env` loading (shared by `discovery.py` and `apply.py`) |
| `utils/io.py` | Shared `load_json()` for inventory/remapping reads |
| `utils/cli.py` | `-h`/`--help` guard before heavy imports |
| `utils/http_client.py` | `BaseVictorOpsClient` — shared session, auth, retries, rate limit |
| `utils/rate_limiter.py` | Shared `RateLimiter` (VictorOps API throttle) |
| `utils/summary_reporter.py` | Markdown `inventory_summary.md` generation from on-disk JSON |
| `utils/exceptions.py` | `MigrationError`, `NetworkError`, `ApiError` |
| `utils/migration_types.py` | Shared type aliases (`InventoryCounts`, etc.) |
| `utils/team_scope.py` | Scoped discovery filtering (team slugs, policy closure, alert/routing-key subset) |
| `tests/` | Mocked unit tests (~84 tests across 13 modules; no live API calls) |
| `docs/` | Migration guide, validation template, troubleshooting |
| `inventory/` | API export output and `remapping.json` (gitignored) |
| `manual_capture/` | Manual capture templates and operator notes (tracked); filled `integrations/*.json` gitignored |
| `README.md` | Quick start, workflow, scope |
| `.env` | Source/target API credentials (gitignored) |
| `.env.example` | Credential template |

**Installation and configuration:** Same as [README Quick Start](../README.md#quick-start). Scripts load `.env` from the project root automatically (not cwd-dependent). Shell `export` values take precedence over `.env`.

**Run scripts:**

```bash
python3 discovery.py
# uv (project venv):  uv run python3 discovery.py
# uv (ephemeral):     uv run --with requests python3 discovery.py
```

Replace `discovery.py` with any pipeline script (`validate_inventory.py`, `generate_remapping.py`, `validate_apply.py`, `apply.py`, `apply_contact_methods_and_policies.py`).

Every pipeline script supports `-h` / `--help` for flags and defaults (e.g. `python3 apply.py -h`).

### CLI reference

| Script | Flags | Default paths |
| :--- | :--- | :--- |
| `discovery.py` | `--inventory`, `--teams`, `--teams-file` | `inventory`; scoped: comma-separated team slugs or file |
| `validate_inventory.py` | `--inventory` | `inventory` |
| `generate_remapping.py` | `--inventory`, `--remapping`, `--username-suffix` | `inventory`, `inventory/remapping.json`, `""` (no suffix) |
| `validate_apply.py` | `--inventory`, `--remapping` | same |
| `apply.py` | `--apply`, `--inventory`, `--remapping` | same |
| `apply_contact_methods_and_policies.py` | `--apply`, `--inventory`, `--remapping` | same |

**Run tests:**

```bash
python3 -m unittest discover -s tests -t . -v
# uv: uv run python3 -m unittest discover -s tests -t . -v
```

---

## Phase 1: API discovery

### Pipeline

| Phase | Scope | Exports |
| :--- | :--- | :--- |
| 1/4 Global | Org-wide list endpoints | users, teams, routing keys, alert rules, webhooks |
| 2/4 User-scoped | Per-user loop | contact methods, paging policies |
| 3/4 Team-scoped | Per-team loop | members, admins, rotation definitions, escalation summaries, schedules, active overrides |
| 4/4 Policy details | Per unique policy slug | full escalation steps and entries |

Integrations are skipped — no public list endpoint exists.

### Scoped discovery (partial export)

Limit discovery to specific teams by **slug** (API identifier, not display name):

```bash
python3 discovery.py --teams team-1234,team-5678,team-9012
python3 discovery.py --teams-file inventory/team_scope.txt
```

- Slugs are comma-separated; whitespace is stripped. Shell quotes are optional (`"a,b"`).
- Unknown slugs fail fast with an error listing invalid values.
- Scoped export includes: selected teams, members/admins/rotations/schedules/overrides for those teams, users referenced by those teams, escalation policies (with **transitive `policy_routing` closure**), matching routing keys, and alert rules whose `alertField` is `routing_key` and whose match value is an in-scope routing key.
- **Excluded in scoped mode:** outbound webhooks (empty list), alert rules with non-`routing_key` fields, org data for teams outside scope.
- Policy closure may add teams not listed in `--teams`; see `discovery_metadata.json` → `scope.expanded_teams`.
- Full-org discovery is unchanged when `--teams` / `--teams-file` are omitted.

### Inventory files

| File | Scope | Notes |
| :--- | :--- | :--- |
| `users_inventory.json` | Global | User accounts |
| `teams_inventory.json` | Global | Team slugs and metadata |
| `routing_keys_inventory.json` | Global | Alert routing keys |
| `alert_rules_inventory.json` | Global | Rules sorted by `rank` |
| `outbound_webhooks_inventory.json` | Global | Outbound webhook definitions |
| `contact_methods_inventory.json` | Per-user | Devices, emails, phones |
| `paging_policies_inventory.json` | Per-user | Primary paging policy steps (list per username) |
| `team_members_inventory.json` | Per-team | User-to-team mapping |
| `team_admins_inventory.json` | Per-team | Team administrators |
| `escalation_policies_inventory.json` | Per-team | Policy summaries (name, slug) |
| `escalation_policy_details_inventory.json` | Per-policy | Steps, entries, timeouts |
| `rotation_definitions_inventory.json` | Per-team | Shift config: members, masks, timezone |
| `schedules_inventory.json` | Per-team | Computed on-call calendar (not rotation config) |
| `scheduled_overrides_inventory.json` | Per-team | Active overrides only |
| `discovery_metadata.json` | Global | Counts, timestamps, `files_written`, `manual_capture_required` |
| `inventory_summary.md` | Global | Human-readable Markdown catalog (written by `SummaryReporter`) |
| `remapping.json` | Global | Source-to-target identifier map (steps 3–7) |
| `apply_report.json` | Global | Per-step apply stats and slug maps (after apply) |

### Runtime

Discovery is read-only and throttled (~2 req/sec). Large orgs (1,000+ users, 200+ teams) expect ~30–40 minutes and ~3,000+ API calls. Output goes to `inventory/`; logs to `discovery_run.log`.

### Deliberately excluded

Incidents, alerts, point-in-time on-call snapshots, expired overrides, reporting APIs, per-user team lists (use team-centric members instead).

### Key implementation notes

- `VictorOpsClient.get()` returns full dicts for multi-list responses (e.g. contact methods)
- `required=True` on critical endpoints raises `ApiError` on 404; network failures raise `NetworkError`
- Shared `RateLimiter` in `utils/rate_limiter.py` used by discovery and apply clients (~2 req/sec)
- `SummaryReporter` (injected into `DiscoveryPipeline`) writes `inventory_summary.md` from on-disk JSON only
- Overrides fetched org-wide via `GET /overrides`, filtered to active only
- Escalation policies: global `GET /policies` grouped by team; details via `GET /policies/{slug}`
- Rotations: `GET /v2/team/{slug}/rotations` (distinct from schedule calendar)

---

## Phase 2: Manual capture

Three gaps have no public API. Capture from the Splunk On-Call portal and your identity provider. See [`manual_capture/README.md`](../manual_capture/README.md) for the step-by-step checklist.

| Gap | Location | Source |
| :--- | :--- | :--- |
| Integrations | `manual_capture/integrations/` | Portal, Integrations |
| User permissions | `manual_capture/user_permissions/admin_users.md` | Settings, Organization, Users |
| SSO settings | `manual_capture/sso/idp_config.md` | IdP admin console |

**Status tracker:** `manual_capture/capture_status.json`

### Integrations to verify

Common types: ServiceNow, Slack, REST/Generic, outbound webhooks. Cross-reference `alert_rules_inventory.json` and `outbound_webhooks_inventory.json` for hints — do not duplicate secrets.

### SSO constants (Splunk On-Call standard)

| Setting | Value |
| :--- | :--- |
| ACS / Reply URL | `https://sso.victorops.com/sp/ACS.saml2` |
| Entity ID | `victorops.com` |
| Relay state | `https://portal.victorops.com/auth/sso/{org_slug}` |

SSO backend config is coordinated with Splunk support; document IdP-side settings only.

### Security

- Never commit API keys, webhook signatures, integration credentials, or SAML metadata
- Store secrets in a vault; reference paths in templates only
- `inventory/`, `.env`, and filled `manual_capture/integrations/*.json` (except `integration.example.json`) are gitignored

---

## Remapping (step 3)

`generate_remapping.py` produces seven categories: `users`, `emails`, `teams`, `routing_keys`, `escalation_policies`, `alert_rules`, `outbound_webhooks`. Output defaults to `inventory/remapping.json`. Set any value to `null` to skip that resource. Re-running the generator overwrites the file.

**Usernames:** Usernames are globally unique across the entire Splunk On-Call environment (shared across orgs). By default the generator maps each source username to itself. Pass `--username-suffix=-splunk` (the leading `-` requires the `=` form) to append a suffix to every target username value, keeping the source username as the key: `python3 generate_remapping.py --username-suffix=-splunk`. Both `apply.py` and `apply_contact_methods_and_policies.py` resolve user references through `remapping.users`, so the suffix cascades to members, rotations, escalation-policy user steps, and deferred user settings. Emails are not suffixed.

**Email addresses:** The `emails` category maps source addresses to target addresses (for example when the target org uses a different email domain). Entries are collected from `users_inventory.json` and escalation-policy email steps in `escalation_policy_details_inventory.json`. Apply uses remapped emails when creating users, building escalation-policy email steps, and posting email contact methods (deferred script). Set a source address to `null` to skip user creation for that address and omit matching escalation steps.

**Alert rule routing keys:** The generator populates `routing_keys` only from `routing_keys_inventory.json`. Rules with `alertField: routing_key` may use pattern match values (for example rotation names) that are not listed as org routing keys. `validate_apply.py` fails if a non-skipped rule references a match value missing from `remapping.routing_keys`. Add the match value under `routing_keys` with the desired target name, or set the rule ID to `null` in `alert_rules` to skip it.

Validate before apply:

```bash
python3 validate_inventory.py
python3 validate_apply.py
```

Note: `validate_apply.py` checks remapping integrity for primary apply resources only — not contact methods or paging policies. Skipped users (`null` in remapping) on active teams or in rotation shift members produce **warnings**, not errors.

---

## Phase 3: Apply

`apply.py` provisions a target org from `inventory/` using `inventory/remapping.json`.

### Environment

```
TARGET_SPLUNK_ONCALL_API_ID
TARGET_SPLUNK_ONCALL_API_KEY
TARGET_SPLUNK_ONCALL_ORG_SLUG
```

### Commands

```bash
python3 apply.py -h                                           # flags and defaults
python3 apply.py                                              # dry-run (default)
python3 apply.py --apply                                      # execute writes
python3 apply.py --inventory inventory --remapping inventory/remapping.json
```

| Flag | Default | Purpose |
| :--- | :--- | :--- |
| `--apply` | off | Execute writes (default is dry-run) |
| `--inventory` | `inventory` | Inventory directory path |
| `--remapping` | `inventory/remapping.json` | Remapping file path |

Apply report is written to `{inventory}/apply_report.json` (includes stats and a `failures` block for post-mortem).

For rotation 500 → policy 400 → routing-key 400 cascade failures, user 409 email conflicts, and deferring users via `null`, see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md).

### Apply order

```mermaid
flowchart LR
    users[Users] --> teams[Teams]
    teams --> members[Members]
    members --> rotations[Rotations]
    rotations --> policies[EscalationPolicies]
    policies --> routingKeys[RoutingKeys]
    routingKeys --> alertRules[AlertRules]
```

| Step | API | Notes |
| :--- | :--- | :--- |
| Users | `POST /user` | Remap usernames; skip `null` entries |
| Teams | `POST /team` | Capture returned slug (API-assigned) |
| Members | `POST /team/{slug}/members` | After users and teams exist |
| Admins | — | **No public POST API** — configure in target UI |
| Rotations | `POST /teams/{team}/rotations` | Map source `rtg-*` slugs via label after create |
| Escalation policies | `POST /policies` | **Immutable after create via API** — includes full steps |
| Routing keys | `POST /org/routing-keys` | Target policy slugs from apply step |
| Alert rules | `POST /alertRules` | Preserve `rank`; remap routing-key matches |

### Re-running apply

Apply is designed to be **partially idempotent**. If you run `python3 apply.py --apply` again with the same inventory and remapping:

| Step | On re-run | If something was wrong the first time |
| :--- | :--- | :--- |
| Users | Skipped when target username already exists | Cannot rename via apply; adjust in target UI or set user to `null` in remapping |
| Teams | Skipped when team **name** already exists | Slug comes from the API; remapping `teams` value is not sent on create |
| Members | Skipped when user is already on the team | Safe to re-run to add missing members |
| Rotations | Skipped when rotation **label** already exists on the team | Cannot update rotation config via re-apply |
| Escalation policies | Skipped when `GET /policies/{source_slug}` finds a policy | **Steps cannot be updated via API** — fix in UI or delete/recreate manually |
| Routing keys | Posted again (no duplicate check) | May error or duplicate; clean up in target UI before re-running |
| Alert rules | Posted again (no duplicate check) | May error or duplicate; remove conflicting rules in target UI first |

Use a dry run before any repeat apply and compare `inventory/apply_report.json` stats (`created` vs `skipped` vs `failed`) and the `failures` block. After the first successful apply, keep `apply_report.json` — its `slug_maps` show how source IDs mapped to target slugs for routing keys and policies.

---

## Phase 3b: Deferred user settings

`apply_contact_methods_and_policies.py` migrates per-user contact methods and primary paging policy steps. Run it **after** `apply.py --apply` has created users in the target org.

### Prerequisites

- Target users must already exist (from primary apply).
- `inventory/contact_methods_inventory.json` and `inventory/paging_policies_inventory.json` from discovery.
- Same `inventory/remapping.json` as primary apply (username and email remapping).

### Commands

```bash
python3 apply_contact_methods_and_policies.py -h
python3 apply_contact_methods_and_policies.py              # dry-run (default)
python3 apply_contact_methods_and_policies.py --apply       # execute writes
```

| Step | API | Notes |
| :--- | :--- | :--- |
| Email contact methods | `POST /user/{username}/contact-methods/emails` | Inventory `value` → POST body `email`; remap via `remapping.emails`; skip `null` |
| Phone contact methods | `POST /user/{username}/contact-methods/phones` | Inventory `value` → POST body `phone`; posted as-is |
| Push devices | — | **Not migrated** — requires user login on target |
| Paging policy steps | `POST /profile/{username}/policies` | Maps inventory `{timeout, contactType}` → `{timeout, rules: [{type, contact?}]}`; email/phone rules require matching contact methods on the target user first |

Apply contact methods before paging steps for the same user. Email and phone paging rules reference contact IDs from the target user's contact methods. Push rules use `{type: "push"}` only.

The script iterates the union of users in `contact_methods_inventory.json` and `paging_policies_inventory.json`.

### Re-running deferred apply

On `--apply`, the script GETs existing contact methods and profile paging steps before POSTing. Matching emails, phones, and `(timeout, contactType)` paging steps are **skipped**. Duplicate POSTs for the same email or phone return HTTP 500 from the API, so the GET preflight is required for safe re-runs. Paging steps can still duplicate if the signature differs (for example, same `contactType` with a different `timeout`). Dry-run simulates POSTs only and does not query the target org.

---

## Validation checklist

After discovery run:

- [ ] `python3 validate_inventory.py` passes
- [ ] All teams in `teams_inventory` have entries in `team_members`, `team_admins`, `rotation_definitions`, `schedules`
- [ ] Every policy slug in routing key targets appears in `escalation_policy_details`
- [ ] `discovery_metadata.json` counts and `files_written` match on-disk files
- [ ] Zero HTTP 404s on required endpoints in `discovery_run.log`
- [ ] Unit tests pass
- [ ] Optional: fill in [`VALIDATION_REPORT.md`](VALIDATION_REPORT.md) template

Before apply:

- [ ] `python3 generate_remapping.py` run (or `inventory/remapping.json` manually maintained)
- [ ] Alert-rule routing key match values are present in `remapping.json` or the rule ID is set to `null`
- [ ] `python3 validate_apply.py` passes (warnings for skipped users are OK)
- [ ] `python3 apply.py` dry-run reviewed
- [ ] If apply fails, see [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md)

After primary apply (deferred user settings):

- [ ] `python3 apply_contact_methods_and_policies.py` dry-run reviewed (contact methods + paging steps)
- [ ] `python3 apply_contact_methods_and_policies.py --apply` executed
- [ ] Push paging steps expected to warn until users register devices on target

After manual capture:

- [ ] Every enabled integration tile has a JSON file in `manual_capture/integrations/`
- [ ] Global admins recorded; team admins spot-checked against API inventory
- [ ] IdP SSO documented with correct relay state for org slug
- [ ] `capture_status.json` all items `complete`

---

## Related documentation

- [`README.md`](../README.md) — quick start, installation, workflow
- [`VALIDATION_REPORT.md`](VALIDATION_REPORT.md) — post-discovery validation template
- [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) — apply failures and edge cases
- [`manual_capture/README.md`](../manual_capture/README.md) — integrations, permissions, SSO capture
- [VictorOps public API docs](https://portal.victorops.com/public/api-docs.html)
- [Splunk On-Call SSO documentation](https://help.splunk.com/en/splunk-enterprise/alert-and-respond/splunk-on-call/introduction-to-splunk-on-call/single-sign-on)
