#!/usr/bin/env python3
"""Decide whether a GUT run passed, from its JUnit report rather than Godot's exit code.

Godot aborts during its own shutdown on Linux, after every test has run and the report has been
written: exit 134, no message, nothing in the log between "All tests passed!" and the core dump.
The same build (4.8.dev4.official.b56a91878) exits cleanly on Windows and macOS, and
`godot --headless --path . --quit` on this project exits 0 on Linux with either audio driver, so it
is GUT's teardown rather than the project or the engine alone.

So the report is the source of truth. A real test failure still fails the build; a crash after a
clean report is reported as a warning and does not.

    python tools/check_gut_report.py <report.xml> <godot exit code>
"""

from __future__ import annotations

import sys
import xml.etree.ElementTree as ET
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__)
        return 2

    report, status = Path(sys.argv[1]), sys.argv[2]

    if not report.exists():
        print(f"::error::No test report at {report}; Godot exited {status} before finishing.")
        return 1

    try:
        root = ET.parse(report).getroot()
    except ET.ParseError as exc:
        print(f"::error::Test report at {report} is not valid XML ({exc}); "
              f"Godot exited {status}.")
        return 1

    suites = list(root.iter("testsuite"))
    if not suites:
        print(f"::error::Test report at {report} contains no test suites; Godot exited {status}.")
        return 1

    tests = sum(int(s.get("tests", 0)) for s in suites)
    failures = sum(int(s.get("failures", 0)) for s in suites)
    errors = sum(int(s.get("errors", 0)) for s in suites)
    print(f"{tests} tests, {failures} failures, {errors} errors (Godot exited {status})")

    if failures or errors:
        print("::error::Tests failed.")
        return 1

    if tests == 0:
        print(f"::error::The report lists no tests at all; Godot exited {status}.")
        return 1

    if status != "0":
        print(f"::warning::Every test passed, but Godot exited {status} during shutdown. This is "
              "the known Linux-only abort in GUT's teardown; the report above is the real result.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
