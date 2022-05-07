KVM Switch
built from $5 HDMI switch + custom hardware

Details: https://hw-by-design.blogspot.com/2018/07/low-cost-kvm-switch.html

Hardware/ - Eagle CAD schematic, PCB, Sketchup 3D model (zipped)
Firmware/ - STM8S003 firmware source code for hotkey
KVM-Hotkey/ - initial test code I used during development.  
Included here for archive and completeiness because of my hosting changes.

Firmware written by me are licensed under GPL 3.0. 
Additional incorporated code are under their own licenses.

Hardware is licensed under CC BY-4.0

https://creativecommons.org/licenses/by/4.0/

Updates: change to Right CTRL key as hotkey.

Updates:

- Optional active or'ing circuit to replace Schottky diodes for lower voltage drops.

Or'ing circuit imspired by RPi 3 Model B rev. 1.2 USB power circuit. The matching transistor pair is
not needed - verified by simulation.  Voltage drop (roughly 50mV @0.5A). The circuit can share current
from multiple USB supplies.

- new USB Mux-v0.2 PCB layout with larger wiring pads, pads for optional or'ing circuit

