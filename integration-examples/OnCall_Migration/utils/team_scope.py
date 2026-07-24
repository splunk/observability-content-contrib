"""Team-scoped discovery helpers (slug-based filtering, no HTTP)."""

from __future__ import annotations

from pathlib import Path
from typing import Any, Dict, Iterable, List, Set


def parse_teams_arg(teams: str) -> List[str]:
    return [slug.strip() for slug in teams.split(",") if slug.strip()]


def parse_teams_file(path: Path) -> List[str]:
    slugs: List[str] = []
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        slugs.append(line)
    return slugs


def unknown_team_slugs(requested: Iterable[str], all_teams: List[Any]) -> List[str]:
    known = {team.get("slug") for team in all_teams if isinstance(team, dict) and team.get("slug")}
    return sorted(slug for slug in requested if slug not in known)


def filter_teams(all_teams: List[Any], team_slugs: Set[str]) -> List[Any]:
    return [team for team in all_teams if isinstance(team, dict) and team.get("slug") in team_slugs]


def filter_users(all_users: List[Any], usernames: Set[str]) -> List[Any]:
    return [
        user for user in all_users if isinstance(user, dict) and user.get("username") in usernames
    ]


def policy_slug_from_summary(policy_entry: Dict[str, Any]) -> str:
    policy = policy_entry.get("policy") or {}
    return policy.get("slug") or ""


def filter_policies_list(policies_list: List[Any], team_slugs: Set[str]) -> List[Any]:
    filtered: List[Any] = []
    for entry in policies_list:
        if not isinstance(entry, dict):
            continue
        team_slug = (entry.get("team") or {}).get("slug")
        if team_slug in team_slugs:
            filtered.append(entry)
    return filtered


def group_policies_by_team(
    policies_list: List[Any],
    team_slugs: Set[str],
    policy_slugs: Set[str],
) -> Dict[str, List[Any]]:
    grouped: Dict[str, List[Any]] = {}
    for entry in policies_list:
        if not isinstance(entry, dict):
            continue
        team_slug = (entry.get("team") or {}).get("slug")
        slug = policy_slug_from_summary(entry)
        if team_slug in team_slugs and slug in policy_slugs:
            grouped.setdefault(team_slug, []).append(entry)
    return grouped


def team_slugs_for_policies(policies_list: List[Any], policy_slugs: Set[str]) -> Set[str]:
    teams: Set[str] = set()
    for entry in policies_list:
        if not isinstance(entry, dict):
            continue
        slug = policy_slug_from_summary(entry)
        if slug not in policy_slugs:
            continue
        team_slug = (entry.get("team") or {}).get("slug")
        if team_slug:
            teams.add(team_slug)
    return teams


def expand_policy_closure(details: Dict[str, Any], seed_slugs: Set[str]) -> Set[str]:
    expanded = set(seed_slugs)
    pending = list(seed_slugs)
    while pending:
        slug = pending.pop()
        for step in details.get(slug, []) or []:
            if not isinstance(step, dict):
                continue
            for entry in step.get("entries", []) or []:
                if not isinstance(entry, dict):
                    continue
                if entry.get("executionType") != "policy_routing":
                    continue
                dep = (entry.get("targetPolicy") or {}).get("policySlug")
                if dep and dep not in expanded:
                    expanded.add(dep)
                    pending.append(dep)
    return expanded


def policy_slug_from_routing_target(target: Dict[str, Any]) -> str:
    slug = target.get("policySlug")
    if slug:
        return slug
    policy_url = target.get("policyUrl") or target.get("_policyUrl") or ""
    if policy_url:
        return policy_url.rstrip("/").split("/")[-1]
    return ""


def filter_routing_keys(routing_keys: List[Any], policy_slugs: Set[str]) -> List[Any]:
    filtered: List[Any] = []
    for routing_key in routing_keys:
        if not isinstance(routing_key, dict):
            continue
        targets = []
        for target in routing_key.get("targets", []) or []:
            if not isinstance(target, dict):
                continue
            slug = policy_slug_from_routing_target(target)
            if slug and slug in policy_slugs:
                targets.append(target)
        if not targets:
            continue
        copy = dict(routing_key)
        copy["targets"] = targets
        filtered.append(copy)
    return filtered


def routing_key_names(routing_keys: List[Any]) -> Set[str]:
    return {
        routing_key.get("routingKey")
        for routing_key in routing_keys
        if isinstance(routing_key, dict) and routing_key.get("routingKey")
    }


def filter_alert_rules(rules: List[Any], routing_key_names: Set[str]) -> List[Any]:
    filtered: List[Any] = []
    for rule in rules:
        if not isinstance(rule, dict):
            continue
        if rule.get("alertField") != "routing_key":
            continue
        match_value = rule.get("alertValueMatch", "")
        if match_value in routing_key_names:
            filtered.append(rule)
    filtered.sort(key=lambda item: item.get("rank", 0))
    return filtered


def _team_user_entries(team_payload: Any) -> List[Any]:
    if isinstance(team_payload, list):
        return team_payload
    if isinstance(team_payload, dict):
        for key in ("members", "admins"):
            entries = team_payload.get(key)
            if isinstance(entries, list):
                return entries
    return []


def collect_usernames(
    members_by_team: Dict[str, Any],
    rotations_by_team: Dict[str, Any],
    team_slugs: Set[str],
    admins_by_team: Dict[str, Any] | None = None,
    policy_details: Dict[str, Any] | None = None,
    policy_slugs: Set[str] | None = None,
) -> Set[str]:
    usernames: Set[str] = set()
    for team_slug in team_slugs:
        for member in _team_user_entries(members_by_team.get(team_slug)):
            if isinstance(member, dict) and member.get("username"):
                usernames.add(member["username"])
        if admins_by_team:
            for admin in _team_user_entries(admins_by_team.get(team_slug)):
                if isinstance(admin, dict) and admin.get("username"):
                    usernames.add(admin["username"])
        rotation_payload = rotations_by_team.get(team_slug, {})
        if not isinstance(rotation_payload, dict):
            continue
        for rotation in rotation_payload.get("rotations", []) or []:
            if not isinstance(rotation, dict):
                continue
            for shift in rotation.get("shifts", []) or []:
                if not isinstance(shift, dict):
                    continue
                for shift_member in shift.get("shiftMembers", []) or []:
                    if isinstance(shift_member, dict) and shift_member.get("username"):
                        usernames.add(shift_member["username"])

    if policy_details:
        slugs = policy_slugs if policy_slugs is not None else set(policy_details.keys())
        for slug in slugs:
            for step in policy_details.get(slug, []) or []:
                if not isinstance(step, dict):
                    continue
                for entry in step.get("entries", []) or []:
                    if not isinstance(entry, dict):
                        continue
                    if entry.get("executionType") != "user":
                        continue
                    username = (entry.get("user") or {}).get("username")
                    if username:
                        usernames.add(username)
    return usernames


def filter_overrides(overrides_grouped: Dict[str, Any], team_slugs: Set[str]) -> Dict[str, Any]:
    return {team: items for team, items in overrides_grouped.items() if team in team_slugs}


def filter_policy_details(details: Dict[str, Any], policy_slugs: Set[str]) -> Dict[str, Any]:
    return {slug: steps for slug, steps in details.items() if slug in policy_slugs}


def seed_policy_slugs(policies_list: List[Any], team_slugs: Set[str]) -> Set[str]:
    slugs: Set[str] = set()
    for entry in filter_policies_list(policies_list, team_slugs):
        slug = policy_slug_from_summary(entry)
        if slug:
            slugs.add(slug)
    return slugs
