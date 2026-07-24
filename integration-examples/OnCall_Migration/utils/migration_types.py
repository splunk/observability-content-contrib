"""Shared type aliases for Splunk On-Call migration scripts."""

from __future__ import annotations

from typing import Any, Dict, List, Optional

JsonDict = Dict[str, Any]
JsonList = List[Any]
InventoryCounts = Dict[str, int]
RemappingTable = Dict[str, Dict[str, Optional[str]]]
