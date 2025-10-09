import os
import socket
import shutil
from typing import Dict
import logging


class HealthCheck:
    def __init__(self):
        self.logger = logging.getLogger(__name__)

    def check_system_resources(self) -> Dict[str, bool]:
        checks = {
            "disk_space": self._check_disk_space(),
            "network": self._check_network(),
            "file_permissions": self._check_file_permissions(),
        }
        self._log_health_status(checks)
        return checks

    def _check_disk_space(self, min_space_gb: float = 1.0) -> bool:
        """Check if there's sufficient disk space using standard lib shutil"""
        try:
            total, used, free = shutil.disk_usage("/")
            free_gb = free // (2**30)  # Convert bytes to GB
            return free_gb >= min_space_gb
        except Exception as e:
            self.logger.error(f"Error checking disk space: {e}")
            return False

    def _check_network(self) -> bool:
        """Basic network connectivity check using standard socket library"""
        try:
            # Try to connect to Google's DNS server
            socket.create_connection(("8.8.8.8", 53), timeout=3)
            return True
        except Exception as e:
            self.logger.error(f"Error checking network: {e}")
            return False

    def _check_file_permissions(self) -> bool:
        """Check if the program has necessary file permissions"""
        try:
            # Try to create a temporary file
            test_file = "permission_test.tmp"
            with open(test_file, "w") as f:
                f.write("test")
            os.remove(test_file)
            return True
        except Exception as e:
            self.logger.error(f"Error checking file permissions: {e}")
            return False

    def _log_health_status(self, checks: Dict[str, bool]):
        for check, status in checks.items():
            if not status:
                self.logger.warning(f"Health check failed for: {check}")
            else:
                self.logger.info(f"Health check passed for: {check}")
