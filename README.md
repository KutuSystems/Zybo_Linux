Zybo_Linux
========

Zybo_Linux repository

This repository is a simple build for the Zybo board that provides full X-Windows support through the HDMI port.

The build supports the original Zybo v1 board, and the Zybo-z7-20 board.

To build it clone this repository, and the XilinxIP repository.  They need to be cloned into the same directory i.e.

git clone https://github.com/KutuSystems/XilinxIP.git
git clone https://github.com/KutuSystems/Zybo_Linux.git

To build it, open Vivado (currently 2018.3) cd to <github>/Zybo_Linux and type source ./create_all_zybo_v1.tcl, or source /create_all_z7-20.tcl

The script changes directory into the XilinxIP, builds the IP blocks, and then generates the project

After the project is created, compile as normal using Vivado, and then export the hardware.

The project is intended as a base for a petalinux based Linux system with a native X-windows interface
