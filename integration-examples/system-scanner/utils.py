import logging
import contextlib
from datetime import datetime
import os


class ContextLogger:
    def __init__(self, logger_name: str, log_file: str = "system_scanner.log"):
        self.logger = logging.getLogger(logger_name)

        # Create logs directory if it doesn't exist
        log_dir = "logs"
        if not os.path.exists(log_dir):
            os.makedirs(log_dir)

        log_path = os.path.join(log_dir, log_file)

        # Configure logging
        formatter = logging.Formatter(
            "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
        )
        file_handler = logging.FileHandler(log_path)
        file_handler.setFormatter(formatter)

        # Add handlers if they don't exist
        if not self.logger.handlers:
            self.logger.addHandler(file_handler)
            self.logger.setLevel(logging.INFO)

        self.start_time = None

    @contextlib.contextmanager
    def operation_context(self, operation: str):
        self.start_time = datetime.now()
        self.logger.info(f"Starting operation: {operation}")
        try:
            yield
        except Exception as e:
            self.logger.error(f"Error during {operation}: {e}")
            raise
        finally:
            duration = datetime.now() - self.start_time
            self.logger.info(
                f"{operation} completed in {duration.total_seconds():.2f}s"
            )
