#!/usr/bin/env python3
"""Light PYNQ-Z2 RGB LED LD4 blue via base overlay.

Requires root to load base.bit (SLCR mmap). Example:
  export XILINX_XRT=/usr
  sudo python3 fpga_blue_led.py 5
"""
import os
import sys
import time

os.environ.setdefault("XILINX_XRT", "/usr")

from pynq.overlays.base import BaseOverlay

BLUE = 1  # bit0 = blue on LD4/LD5


def main() -> int:
    base = BaseOverlay("base.bit")
    led_idx = 4
    base.rgbleds[led_idx].write(BLUE)
    print(f"LD{led_idx} blue ON")
    hold = float(sys.argv[1]) if len(sys.argv) > 1 else 5.0
    time.sleep(hold)
    base.rgbleds[led_idx].off()
    print(f"LD{led_idx} OFF")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
