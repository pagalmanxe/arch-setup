#!/usr/bin/env python3
"""hermes-popover.py — minimal floating composer for Hermes.

Opens a tiny always-on-top window with a text entry + output pane.
Each submission runs `hermes -z "<prompt>"` (one-shot mode) which creates a
FRESH session every time and prints ONLY the final reply. The full Electron
app is never opened.

Requires: python3 + tkinter (both standard on Arch; no extra install).
"""

from __future__ import annotations

import subprocess
import sys
import threading
from pathlib import Path

try:
    import tkinter as tk
    from tkinter import scrolledtext, ttk
except ImportError:
    sys.stderr.write("tkinter is required (usually bundled with python3)\n")
    sys.exit(1)

HERMES_BIN = "/home/laliguras/.local/bin/hermes"


def run_hermes(prompt: str) -> str:
    """Run a one-shot Hermes query. Returns the final response text."""
    try:
        proc = subprocess.run(
            [HERMES_BIN, "-z", prompt],
            capture_output=True,
            text=True,
            timeout=300,
            env={**__import__("os").environ},
        )
        out = (proc.stdout or "").strip()
        if not out and proc.stderr.strip():
            out = proc.stderr.strip()
        return out or "(no response)"
    except subprocess.TimeoutExpired:
        return "(timed out after 300s)"
    except FileNotFoundError:
        return f"hermes binary not found at {HERMES_BIN}"


class Popover(tk.Tk):
    def __init__(self) -> None:
        super().__init__()
        self.title("Hermes")
        # Minimal floating window, always on top, no window decorations.
        self.overrideredirect(True)
        self.attributes("-topmost", True)
        self.configure(bg="#1e1e2e")

        width, height = 520, 360
        self.geometry(f"{width}x{height}")

        style = ttk.Style()
        style.theme_use("clam")
        style.configure(
            "TEntry",
            fieldbackground="#181825",
            background="#181825",
            foreground="#cdd6f4",
            borderwidth=0,
            insertcolor="#cdd6f4",
        )

        # Output pane
        self.output = scrolledtext.ScrolledText(
            self,
            wrap="word",
            bg="#181825",
            fg="#cdd6f4",
            insertbackground="#cdd6f4",
            relief="flat",
            borderwidth=0,
            padx=10,
            pady=8,
            font=("monospace", 11),
            state="disabled",
        )
        self.output.pack(fill="both", expand=True, padx=6, pady=(6, 0))

        # Prompt entry
        self.entry = ttk.Entry(self, style="TEntry", font=("monospace", 12))
        self.entry.pack(fill="x", padx=6, pady=(6, 6))
        self.entry.bind("<Return>", self.on_submit)
        self.entry.bind("<Escape>", lambda _e: self.destroy())
        self.entry.focus_set()

        self.status = tk.Label(
            self,
            text="Enter to send · Esc to close · new session each send",
            bg="#1e1e2e",
            fg="#6c7086",
            font=("monospace", 9),
        )
        self.status.pack(fill="x", padx=6, pady=(0, 6))

        # Center on the primary monitor.
        self.update_idletasks()
        self._center(width, height)

    def _center(self, w: int, h: int) -> None:
        try:
            import screeninfo  # optional

            mon = screeninfo.get_monitors()[0]
            x = mon.x + (mon.width - w) // 2
            y = mon.y + (mon.height - h) // 3
            self.geometry(f"{w}x{h}+{x}+{y}")
        except Exception:
            # Fallback: try xrandr-free guess via tkinter screenmetrics.
            sw = self.winfo_screenwidth()
            sh = self.winfo_screenheight()
            self.geometry(f"{w}x{h}+{(sw - w) // 2}+{(sh - h) // 3}")

    def on_submit(self, _event=None) -> None:
        prompt = self.entry.get().strip()
        if not prompt:
            return
        self.entry.delete(0, "end")
        self._append(f"\n› {prompt}\n", "#89b4fa")
        self.status.configure(text="working…")
        threading.Thread(target=self._worker, args=(prompt,), daemon=True).start()

    def _worker(self, prompt: str) -> None:
        reply = run_hermes(prompt)
        self.after(0, self._show_reply, reply)

    def _show_reply(self, reply: str) -> None:
        self._append(f"{reply}\n", "#cdd6f4")
        self.status.configure(text="Enter to send · Esc to close · new session each send")
        self.entry.focus_set()

    def _append(self, text: str, color: str) -> None:
        self.output.configure(state="normal")
        self.output.insert("end", text, color)
        self.output.tag_config(color, foreground=color)
        self.output.see("end")
        self.output.configure(state="disabled")


if __name__ == "__main__":
    Popover().mainloop()
