#!/bin/bash
#
# Installation script.
#
# Copyright (C) 2005, 2006  Charles Bouveyron <charles.bouveyron@free.fr>
# Copyright (C) 2025  Tomáš Hnyk <tomashnyk@gmail.com>
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

# If there is no kdialog, create an error log and abort.
if ! command -v kdialog >/dev/null 2>&1; then
    touch ~/kim6_installation_failed.log
    echo "You tried to install KDE Image Menu 6 (KIM 6) service menu for KDE's Dolphin file manager in an environment that does not have kdialog. Most of the functionality would not work and the installation was aborted. Please install KDE or kdialog and try again. This message was created by this command: $(realpath "$0")." > ~/kim6_installation_failed.log
    exit 1
fi

# Function to show install errors and declare install_log variable to store the errors
install_log=""
spit_install_log() {
    kdialog --title "KIM 6 Installation problems" --error="$install_log"
}

# Test for presence of dependencies, if not present, a user is presented with a log after installation
if ! command -v montage >/dev/null 2>&1; then
    install_log="$install_log""Cannot find executable <b>montage</b>. Please install it. It is usually in package <b>imagemagick</b> (Debian etc, Arch) or <b>ImageMagick</b> (Fedora etc.). Without it, the montage feature will not work.<br><br>"
fi
if ! command -v mogrify >/dev/null 2>&1; then
    install_log="$install_log""Cannot find executable <b>mogrify</b>. Please install it. It is usually in package <b>imagemagick</b> or <b>ImageMagick</b>. Without it, a lot of features like resizing and rotating and other transformations will not work.<br><br>"
fi
if ! command -v convert >/dev/null 2>&1; then
    install_log="$install_log""Cannot find executable <b>convert</b>. Please install it. It is usually in package <b>imagemagick</b> or <b>ImageMagick</b> Without it, format conversion will not work.<br><br>"
fi
if ! command -v ffmpeg >/dev/null 2>&1; then
    install_log="$install_log""Cannot find executable <b>ffmpeg</b>. Please install it. It is usually in package <b>ffmpeg</b>. Without it, video resizing will not work.<br><br>"
else
   if ! ffmpeg -encoders 2>&1 | grep -q libx264; then
       install_log="$install_log""Cannot find encoder <b>libx264</b> for FFmpeg. Encoding video with it will not work. Please install it.<br><br>"
   fi
   if ! ffmpeg -encoders 2>&1 | grep -q libx265; then
       install_log="$install_log""Cannot find encoder <b>libx265</b> for FFmpeg. Encoding video with it will not work. Please install it.<br><br>"
   fi
fi
if ! command -v xdg-email >/dev/null 2>&1; then
    install_log="$install_log""Cannot find executable <b>xdg-email</b>. Please install it. It is usually in package <b>xdg-utils</b>. Without it, sending an image by e-mail will not work.<br><br>."
fi
if [[ -n "$install_log" ]]; then
    install_log="$install_log""Some <b>dependencies are missing</b>. The installation continued, but some functionality might not work.<br><br>"
fi

# Get install directory according to the XDG standard (previously qtpaths6 were used, but Ubuntu has them in development package)
if [ "$(id -u)" -eq 0 ]; then
    # We are root, installing in system directories
    SYSTEM_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
    for dir in $(echo "$SYSTEM_DIRS" | tr ":" "\n"); do
        if [ -d "$dir/kio/servicemenus" ]; then
            kim_install_dir="$dir/kio/servicemenus"
            break
        fi
    done
else
    # We are not root, installing in user directory
    kim_install_dir="${XDG_DATA_HOME:-$HOME/.local/share}/kio/servicemenus"
fi

# This checks if we got an existing install directory
if [[ ! -d "$kim_install_dir" ]]; then
    install_log="<b>Error</b> fetching the KDE install prefix. Installation was aborted."
    spit_install_log
    exit 1
fi

# Target directory to install helper files
kim_helper_files="$kim_install_dir"/kim6
# Directory from which we install
src_folder="$(dirname "$(realpath "$0")")"

# First uninstall so we do not leave anything behind when potentially renaming, removing or moving stuff from version to version
"$src_folder"/uninstall.sh --no_message

# Test if there are pregenerated .desktop files and if not generate them (normally in a release they would be, during development not)
if compgen -G "$src_folder"/src/kim_*.desktop >/dev/null; then
    desktop_files_generated=false
else
    desktop_files_generated=true
    if ! command -v intltool-merge >/dev/null 2>&1; then
        install_log="$install_log""You are probably trying to install KIM6 from git and do not have pregenerated .desktop files.<br>They are generated by the tool <b>intltool-merge</b>, usually found in package <b>intltool</b>.<br>Please install it. The installation was aborted.<br><br>"
        spit_install_log
        exit 1
    else
        for desk_ini in "$src_folder"/src/*.desktop.in
        do
            new_desktop_file_filename="${desk_ini%.in}"
            intltool-merge --desktop-style "$src_folder"/po/ "$desk_ini"  "$new_desktop_file_filename" > /dev/null
            chmod +x "$new_desktop_file_filename"
        done
    fi
fi

# install helper files and desktop files
mkdir -p "$kim_helper_files"

cp -pr "$src_folder"/src/gallery \
       "$src_folder"/po \
       "$src_folder"/src/bin \
       "$src_folder"/src/kim_translation \
       "$src_folder"/ABOUT \
       "$src_folder"/LICENSE \
       "$kim_helper_files"/

# copy docs if present
if [ -d "$src_folder/docs" ]; then
    cp -pr "$src_folder"/docs "$kim_helper_files"/
fi

cp -pr "$src_folder"/src/kim_*.desktop "$kim_install_dir"

# Replace the path in desktop and other files with the installed path
for file in "$kim_install_dir"/kim_*.desktop; do
    sed -i "s|Exec=kim|Exec=$kim_helper_files/bin/kim|g" "$file"
done
for file in "$kim_helper_files"/bin/kim_*; do
    sed -i "s|KIM_INST_TTT|kim_inst='$kim_helper_files'|g" "$file"
    sed -i "s|SOURCE_TRANSLATION_TTT|. '$kim_helper_files/kim_translation'|g" "$file"
done
sed -i "s|LOCALE_SOURCE_TTT|'$kim_helper_files/locale'|g" "$kim_helper_files/kim_translation"

# install translation mo files
if ! command -v msgfmt >/dev/null 2>&1; then
    install_log="$install_log""The <b>msgfmt</b> command was not found, translation files were not generated and KIM6 will only be available in English. The command is usually provided by the package <b>gettext</b>. Please install it and then install KIM6 again.<br><br>"
else
    for i in "$kim_helper_files"/po/*.po; do
        TRANSLANG=$(basename -s .po "$i")
        mkdir -p "$kim_helper_files/locale/$TRANSLANG/LC_MESSAGES"
        msgfmt -o "$kim_helper_files/locale/$TRANSLANG/LC_MESSAGES/kim6.mo" "$i"
    done
fi

# po files do not need to be installed after generating locale
rm -rf "$kim_helper_files/po"

# in case we generated desktop files, remove them
if [ "$desktop_files_generated" = true ] ; then
    rm "$src_folder"/src/*.desktop
fi
# if errors were encountered, display them, otherwise the success message will only be seen when installed manually from a terminal, not from GUI
if [[ "$install_log" == "" ]]; then
    echo "KIM6 has been successfully installed. Goodbye."
else
    spit_install_log
fi
