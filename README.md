Zybo_Linux
========

Zybo_Linux repository

This repository is a simple build for the Zybo board that provides full X-Windows support through the HDMI port.

To build it clone this repository, and the XilinxIP repository, and copy create_all_projects to the base directory i.e. if this repostory is in /usr/user/github/Zybo_Linux , then copy the script to /usr/user/github.
To build it, open Vivado (currently 2015.1) cd to /usr/user/github and type source ./create_all_projects.tcl.
After the project is created, then compile as normal using Vivado.  Pre-built images are available in the SD_image subdirectory.

regards,
Greg
