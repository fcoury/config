#!/usr/bin/env python3
"""Print "light" or "dark" by asking the terminal for its background color."""

from __future__ import annotations

import os
import re
import select
import sys
import termios
import time

OSC11_QUERY = b"\x1b]11;?\x07"
TMUX_PASSTHROUGH_QUERY = b"\x1bPtmux;\x1b\x1b]11;?\x07\x1b\\"
RGB_RE = re.compile(rb"\]11;rgb:([0-9a-fA-F]+)/([0-9a-fA-F]+)/([0-9a-fA-F]+)")


def channel_to_8bit(component: bytes) -> int:
    value = int(component, 16)
    max_value = (1 << (4 * len(component))) - 1
    return round(value * 255 / max_value)


def classify_background(response: bytes) -> str | None:
    match = RGB_RE.search(response)
    if match is None:
        return None

    red, green, blue = (channel_to_8bit(component) for component in match.groups())
    # Relative luminance in sRGB space; 0.5 is a useful practical split for prompts.
    luminance = (0.2126 * red + 0.7152 * green + 0.0722 * blue) / 255
    return "light" if luminance >= 0.5 else "dark"


def main() -> int:
    try:
        fd = os.open("/dev/tty", os.O_RDWR | os.O_NOCTTY)
    except OSError:
        return 1

    old_attrs = termios.tcgetattr(fd)
    try:
        attrs = termios.tcgetattr(fd)
        attrs[3] &= ~(termios.ICANON | termios.ECHO)
        attrs[6][termios.VMIN] = 0
        attrs[6][termios.VTIME] = 0
        termios.tcsetattr(fd, termios.TCSANOW, attrs)

        query = TMUX_PASSTHROUGH_QUERY if os.environ.get("TMUX") else OSC11_QUERY
        os.write(fd, query)

        deadline = time.monotonic() + 0.15
        chunks: list[bytes] = []
        while time.monotonic() < deadline:
            timeout = max(0.0, deadline - time.monotonic())
            readable, _, _ = select.select([fd], [], [], timeout)
            if not readable:
                break
            chunk = os.read(fd, 1024)
            if not chunk:
                continue
            chunks.append(chunk)
            response = b"".join(chunks)
            theme = classify_background(response)
            if theme is not None:
                print(theme)
                return 0
    finally:
        termios.tcsetattr(fd, termios.TCSANOW, old_attrs)
        os.close(fd)

    return 1


if __name__ == "__main__":
    raise SystemExit(main())
