#!/bin/bash
#
# Uninstallation script.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Unknown
#          Tomáš Hnyk <tomashnyk@gmail.com>

# Get install directory according to the XDG standard (previously qtpaths6 were used, but Ubuntu has them in development package)
# This assumes we installed the same way (root vs normal user) as we uninstall
NO_MESSAGE=$1

if [ "$(id -u)" -eq 0 ]; then
    # We are root, installed in system directories
    SYSTEM_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
    for dir in $(echo "$SYSTEM_DIRS" | tr ":" "\n"); do
        if [ -d "$dir/kio/servicemenus" ]; then
            kim_install_dir="$dir/kio/servicemenus"
            break
        fi
    done
    message1="The KDE servicemenu install prefix could not be determined. Uninstallation was aborted. Uninstall is run as root. Didn't you install as normal user?"
    message2="The KIM 6 executables directory not found. You are trying to uninstall as root. Did you install as normal user?"
else
    # We are not root, installed in user directory
    kim_install_dir="${XDG_DATA_HOME:-$HOME/.local/share}/kio/servicemenus"
    message1="The KDE servicemenu install prefix could not be determined. Uninstallation was aborted. Uninstall is run as normal user. Didn't you install as root?"
    message2="The KIM 6 executables directory not found. You are trying to uninstall as normal user. Did you install as root?"
fi

# This checks if we got an existing install directory
if [[ ! -d "$kim_install_dir" || -z "$kim_install_dir" ]]; then
    echo $message1
    exit 1
fi

if [[ ! -d "$kim_install_dir/kim6" ]]; then
    if [[ $NO_MESSAGE == "--no_message" ]]; then
        : # Say nothing when called from install script
    else
        echo $message2
        NO_MESSAGE="--no_message"
    fi
fi

# Remove desktop files and helper directory
rm -f "$kim_install_dir"/kim_*.desktop 2>/dev/null
rm -rf "$kim_install_dir"/kim6 2>/dev/null

if [[ $NO_MESSAGE == "--no_message" ]]; then
    : # Say nothing when called from install script
else
    echo "KIM6 has been removed. Goodbye."
fi
