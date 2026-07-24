"""Generate human-readable inventory summary reports."""

from __future__ import annotations

import logging
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from utils.io import load_json
from utils.migration_types import InventoryCounts

log = logging.getLogger(__name__)


class SummaryReporter:
    """Writes inventory_summary.md from on-disk inventory JSON."""

    def __init__(self, output_dir: Path, org_slug: str, inventory_counts: InventoryCounts):
        self.output_dir = output_dir
        self.org_slug = org_slug
        self.inventory_counts = inventory_counts

    def write_summary(self, elapsed_seconds: float) -> None:
        """Write a human-readable Markdown catalog from saved inventory JSON."""
        exported_at = datetime.now(timezone.utc).isoformat()
        lines = [
            "# Splunk On-Call Inventory Summary",
            "",
            f"**Org:** {self.org_slug}  ",
            f"**Exported:** {exported_at}  ",
            f"**Duration:** {self._format_duration(elapsed_seconds)}",
            "",
            "## Inventory Counts",
            "",
            "| File | Count |",
            "| --- | ---: |",
        ]

        for name, count in sorted(self.inventory_counts.items()):
            lines.append(f"| `{name}.json` | {count} |")

        teams = self._load_inventory_json("teams_inventory") or []
        team_members = self._load_inventory_json("team_members_inventory") or {}
        team_admins = self._load_inventory_json("team_admins_inventory") or {}
        rotations = self._load_inventory_json("rotation_definitions_inventory") or {}
        escalation_policies = self._load_inventory_json("escalation_policies_inventory") or {}

        lines.extend(["", f"## Teams ({len(teams)})", ""])
        if teams:
            lines.extend([
                "| Name | Slug | Members | Admins | Rotations | Escalation Policies |",
                "| --- | --- | ---: | ---: | --- | ---: |",
            ])
            for team in sorted(teams, key=lambda t: (t.get("name") or "").lower()):
                if not isinstance(team, dict):
                    continue
                slug = team.get("slug", "")
                name = team.get("name", "")
                member_count = len(team_members.get(slug, [])) if isinstance(team_members, dict) else 0
                admin_count = len(team_admins.get(slug, [])) if isinstance(team_admins, dict) else 0
                rotation_labels = self._rotation_labels(
                    rotations.get(slug) if isinstance(rotations, dict) else None
                )
                policy_count = (
                    len(escalation_policies.get(slug, []))
                    if isinstance(escalation_policies, dict)
                    else 0
                )
                lines.append(
                    f"| {self._md_cell(name)} | {self._md_cell(slug)} | {member_count} | "
                    f"{admin_count} | {self._md_cell(rotation_labels)} | {policy_count} |"
                )
        else:
            lines.append("_No teams exported._")

        routing_keys = self._load_inventory_json("routing_keys_inventory") or []
        lines.extend(["", f"## Routing Keys ({len(routing_keys)})", ""])
        if routing_keys:
            lines.extend([
                "| Routing Key | Target Policy | Team Slug |",
                "| --- | --- | --- |",
            ])
            for rk in sorted(routing_keys, key=lambda r: (r.get("routingKey") or "").lower()):
                if not isinstance(rk, dict):
                    continue
                key = rk.get("routingKey", "")
                targets = rk.get("targets") or []
                target = targets[0] if targets and isinstance(targets[0], dict) else {}
                policy_name = target.get("policyName", "")
                team_slug = self._team_slug_from_url(target.get("_teamUrl", ""))
                lines.append(
                    f"| {self._md_cell(key)} | {self._md_cell(policy_name)} | {self._md_cell(team_slug)} |"
                )
        else:
            lines.append("_No routing keys exported._")

        alert_rules = self._load_inventory_json("alert_rules_inventory") or []
        lines.extend(["", f"## Alert Rules ({len(alert_rules)})", ""])
        if alert_rules:
            lines.extend([
                "| Rank | Field | Match | Match Type | Stop |",
                "| ---: | --- | --- | --- | :---: |",
            ])
            for rule in sorted(alert_rules, key=lambda r: r.get("rank", 0)):
                if not isinstance(rule, dict):
                    continue
                lines.append(
                    f"| {rule.get('rank', '')} | {self._md_cell(rule.get('alertField', ''))} | "
                    f"{self._md_cell(rule.get('alertValueMatch', ''))} | "
                    f"{self._md_cell(rule.get('matchType', ''))} | "
                    f"{'Yes' if rule.get('stopFlag') else 'No'} |"
                )
        else:
            lines.append("_No alert rules exported._")

        webhooks = self._load_inventory_json("outbound_webhooks_inventory") or []
        lines.extend(["", f"## Outbound Webhooks ({len(webhooks)})", ""])
        if webhooks:
            lines.extend([
                "| Label | Slug |",
                "| --- | --- |",
            ])
            for wh in webhooks:
                if not isinstance(wh, dict):
                    continue
                lines.append(
                    f"| {self._md_cell(wh.get('label', ''))} | {self._md_cell(wh.get('slug', ''))} |"
                )
        else:
            lines.append("_No outbound webhooks exported._")

        users = self._load_inventory_json("users_inventory") or []
        lines.extend(["", f"## Users ({len(users)})", ""])
        if users:
            lines.extend([
                "| Username | Display Name |",
                "| --- | --- |",
            ])
            for user in sorted(users, key=lambda u: (u.get("username") or "").lower()):
                if not isinstance(user, dict):
                    continue
                lines.append(
                    f"| {self._md_cell(user.get('username', ''))} | "
                    f"{self._md_cell(user.get('displayName', ''))} |"
                )
        else:
            lines.append("_No users exported._")

        overrides = self._load_inventory_json("scheduled_overrides_inventory") or {}
        override_buckets = len(overrides) if isinstance(overrides, dict) else 0
        active_overrides = (
            sum(len(v) for v in overrides.values())
            if isinstance(overrides, dict)
            else 0
        )
        lines.extend([
            "",
            "## Scheduled Overrides",
            "",
            f"- **Team buckets:** {override_buckets}",
            f"- **Active overrides:** {active_overrides}",
            "",
            "## Manual Capture Required",
            "",
            "- integrations",
            "- user_permissions",
            "- sso_settings",
            "",
            "## Notes",
            "",
            "Integrations are not exported via the public API. See "
            "`manual_capture/README.md` for manual capture steps.",
            "",
        ])

        self.output_dir.mkdir(parents=True, exist_ok=True)
        path = self.output_dir / "inventory_summary.md"
        temp_path = path.with_suffix(".tmp")
        temp_path.write_text("\n".join(lines))
        temp_path.replace(path)
        log.info("  -> Saved inventory summary to inventory_summary.md")

    def _load_inventory_json(self, name: str) -> Any:
        return load_json(self.output_dir / f"{name}.json")

    def _format_duration(self, elapsed_seconds: float) -> str:
        minutes, seconds = divmod(int(elapsed_seconds), 60)
        return f"{minutes}m {seconds:02d}s"

    def _team_slug_from_url(self, url: str) -> str:
        if not url:
            return ""
        return url.rstrip("/").split("/")[-1]

    def _rotation_labels(self, rotation_data: Any) -> str:
        if not isinstance(rotation_data, dict):
            return ""
        rotations = rotation_data.get("rotations") or []
        labels = [
            r.get("label", "")
            for r in rotations
            if isinstance(r, dict) and r.get("label")
        ]
        return ", ".join(labels)

    def _md_cell(self, value: Any) -> str:
        return str(value).replace("|", "\\|").replace("\n", " ")
