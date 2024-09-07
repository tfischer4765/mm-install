# mm-install

A single-script-installer to turn PiOS-lite into a magic mirror with minimal ressource wasteage

### **WARNING: This script is currently in beta. Please use with caution and expect bugs!**

## Intended use

This script is intended to prepare a working environment for, install and run MagicMirror2 on a pristine PiOS-lite image. It can easily be set up on SDcards as small as 8GB or possibly even smaller.

### **Important: This script is written under the assumption that the user has a basic understanding of Linux and X. If you don't know how to flash an image onto a sd card or download a file onto your linux disto via CLI, it is suggested you use the official installation method on the MagicMirror2 website. Follow the instructions in this README closely and check your preconditions. Using this script wrong WILL BREAK YOUR IMAGE!**

### What it does

The script asks you to select which steps of the following list you want it to perform. Depending on your selections, some of the following steps may or may not be available:

- Install a minimal X server setup and set it to start at boot
- Set up nodesource and install node.js<sup>1</sup>
- clone and install MagicMirror2 from the official repo<sup>1</sup>
- link configuration and modules to /etc for easy access<sup>1,2</sup>
- set MagicMirror to be started by systemd<sup>1,2</sup>
 <sub>1: Only if requested 2: Only if MM2 install was chosen</sub>

### Preconditions, Limitations and Caveats

- This script assumes you will use that machine to run MagicMirror ONLY. Trying to set it up to do other graphical tasks will most likely break stuff.
- This script is designed to be run on a pristine PiOS lite image. Running it on an image in any other state may result in a broken system.
- Running this script yields an extremely bare-bones X system. While it is certainly possible to run other X applications on it if you know your way around X, it is not intended to do so and will neither be convenient nor fun.
- The script does not break any existing system structures, so other headless software could definitely be installed on the same system, ressources permitting

## Installation

- flash a PiOS lite onto an SD card. It is highly recommended to install an SSH key and wifi credentials while you are at it. If you don't, setting it up is your own responsibility, mm-install makes no provision to do so for you.
- start your Pi, connect to it via your preferred method and do what you feel you need to do to finish the initial configuration
- use curl to download the script from the following location: `https://raw.githubusercontent.com/tfischer4765/mm-install/latest-release/mm-install.sh`, or if you are feeling adventurous, try replacing `latest-release` with `beta` or even `master`
- Run the script in a bash as root. **ROOT, mind you, *not* SUDO - BASH mind you, not just any shell!**
- answer the configuration questions
- let the script do its thing
- perform any cleanup tasks as instructed by the script output
- reboot your system

## MagicMirror configuration

**The following applies ONLY if you selected to install MagicMirror via this script!**

If you selected to link your config to /etc, the following will be available:

- the config.js file is available in /etc/magicmirror/config/config.js
- the modules directory is linked to /etc/magicmirror/modules.

If you did chose to NOT link your config, they will be found in /usr/local/share/magicmirror.

## Advanced configuration

If your system has special requirements, you may need to make use of the following advanced configuration options, that give you finer control over your system

### Controlling the X output

By default, the x server is going to use output HDMI-1. The xinitrc script used to start the X server has provisions for running xrandr to change e.g. output, resolutions and rotation.

To use that possiblity, create a file named xrandr_opts in /etc/magicmirror. In it, you can put any set of command line options xrandr can understand. xrandr will ONLY be executed if this file is present.

*Example: xrandr_opts containing the string `--output LVDS --resolution 640x680 --rotate right` will result in the command `xrandr --output LVDS --resolution 640x680 --rotate right` being executed. `--resolution 640x680 --rotate right` will result in an error, because no output to modify was specified.*

**You are very much encouraged to test the options by manually executing xrandr and observing that the result matches your expectations!**

### Using a custom background image

By default, a solid black background is used.

If you want to use a different background, create a file named `x_background_image` in `/etc/magicmirror` containing a path to an image file. If that file is present and the path in it leads to a readable file, that file will be attempted to be rendered onto the root window instead

**WARNING: The script will not ascertain that the file it gets handed is a valid image file.**

## Troubleshooting

If the script behaves strangely

- check that you are indeed using the latest 64-bit PiOS lite image
- check that you are indeed running it as root, not just via sudo
- check that you are running the script in bash, not some other shell
- check if the files in /tmp/mm-install look sane
- check that the directories the script tries to create don't already exist. The script will refuse to run if they do to avoid clobbering existing installs
- Make sure you haven't previously tried unsuccessfully to run the script. If you've aborted a previous run of the script, it's probably easier to re-flash the SD-card and start over than trying to undo everything
- check that you have network access and your apt repositories are accessible and up to date
- Go to the MagicMirror2 discord and ask for help. I'm normally there under my handle of `@drdeath`

If all else fails, go to `https://github.com/tfischer4765/mm-install` and open an issue
