This folder contains the designs of the PCB designs made for the LuxSenz project. This includes a PCB design for the LuxSenz receiver, and an expansion board for a Nucleo-64 board that is used in the LuxSenz demo transmitter. The files in all folders can be opened in [KiCad](http://kicad-pcb.org) software.

The following folders exist:
- `pcb2`: the PCB design of the LuxSenz receiver
- `pcb3`: the PCB design of the expansion board for Nucleo-64, used in the LuxSenz demo transmitter

Each of these folders contain the following files and subfolders (as well as some other files):
- `library`: library files of components that were not yet available in the default libraries. Most of these libraries have been merged later on into the default KiCad libraries
- `gerber` or `gerber-rev*`: the generated gerber files that were sent to fabricating companies (for revision * of the board)
- `*.pro`: the KiCad project file. This one is the file that must be opened to view the designs in KiCad.