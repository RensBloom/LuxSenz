This folder contains the designs of all 3D-printed parts made for the LuxSenz project. This includes 3D designs of the receiver and transmitter, and a simple casing for a BeagleBone black. The files can be opened in [OpenSCAD](http://www.openscad.org/) software, or the STL files can be used directly to 3D print the parts.

To build a receiver, the following parts need to be printed:
- `receiver_case` once: this is the main casing
- `receiver_block_lens_25mm` twice: blocks to surround the lens

To build a transmitter, the following parts need to be printed:
- `transmitter_case` once: the main part of the casing
- `transmitter_cap` once: the cover to close the casing
- `transmitter_reflective_shield` once, preferably in white: a surface placed behind the shutters that reflects ambient light. This part can be put onto the cover of the casing.
- `transmitter_block_3d_glass_shutter` (or a different one from below) twice: blocks to surround the shutters

The following designs are present to surround shutters:
- `transmitter_block_3d_glass_shutter`: surround a pair of shutters from 3D glasses. Exposed area: 26.3 cm2.

To create a simple casing for a BeagleBone Black (preventing short circuits), the following parts need to be printed:
- `beaglebone_casing_bottom` once: the bottom part of the casing, in which the BeagleBone fits
- `beaglebone_casing_top` once: a cover that can be placed on top of the BeagleBone to close the casing