# KDE Image Menu 6 — KIM6
KIM6 is a service menu for the KDE Plasma desktop. It adds context-menu actions in Dolphin and Folder View so you can resize, convert and batch-process images (and some video formats) directly from the file manager.

KDE store link: https://store.kde.org/p/2307290/

The manual: https://kim-6.github.io/kim6/

![Screenshot](KIM6.png)

## Features

* Process images directly from Dolphin's context menu.
* Compress and resize images for web, sharing or archival.
* Convert between multiple image formats.
* Rotate, flip and losslessly manipulate images.
* Sort images based on EXIF date.
* Batch-rename images with flexible patterns.
* Create HTML galleries, collages and simple GIF animations.
* Reduce or re-encode video clips using FFmpeg (HD or Full HD).

## Dependencies

- **KDE Plasma 6**: Dolphin, KDialog and Qt.
- **ImageMagick**: Required for most image operations.
- **FFmpeg**: Required for video conversion; image functions work without it.
- **xdg-email** from `xdg-utils`: Required for the “send by e-mail” action.

## Install

### Option 1: Install from Dolphin (recommended)

1. Open: Dolphin → Settings → Configure Dolphin → Services.
2. Search for “KIM6” and install it.
3. If it does not appear, try changing the sorting order in Dolphin's service list (reported as https://bugs.kde.org/show_bug.cgi?id=508140)

### Option 2: Install using `servicemenuinstaller` with a downloaded release

1. Download the latest `kim6_*.tar.gz` release from the project’s Releases page.
2. Install it using:

```
servicemenuinstaller install ./kim6*.tar.gz
```
(when run with root priviledges, it will install system-wide)

### Option 3: Install from a cloned repository
```
git clone https://github.com/KIM-6/kim6.git
cd kim6
./install.sh
```
(when run with root priviledges, it will install system-wide)

## Uninstall

### Option 1: Remove from Dolphin

Use Dolphin’s service menu configuration to remove KIM6.  
On some systems, uninstall may need to be triggered twice (reported as https://bugs.kde.org/show_bug.cgi?id=508142).

### Option 2: Remove using `servicemenuinstaller`

If you installed via Dolphion, you can also do:

```
servicemenuinstaller uninstall ~/.local/share/servicemenu-download/kim6*.tar.gz
```

In the unusual case when the archive was stored elsewhere (meaning you have non-standrd `$XDG_DATA_HOME`, you need to locate the archive and change the path above.

### Option 3: Remove from a cloned repository

From inside the cloned repository:
```
./uninstall.sh
```
(if you installed as root, you need to run this as root too)

## Usage

1. Select one or more images in Dolphin or Folder View.
2. Right-click and open the **KIM6** submenu.
3. Choose an action, such as “Compress and resize → Webexport 1920 px”.
4. Confirm whether to overwrite originals or create new files.

You can also run individual scripts (usually stored in `~/.local/share/kio/servicemenus/kim6/bin/`) directly:

```
./kim_resize ~/example.jpg 300x300
```

## History

- KIM6 is a fork for KDE 6 of KIM5: https://github.com/caco3/kim5
- One KDE4 fork is here: https://store.kde.org/p/998188/
- The original version for KDE4 is here: https://store.kde.org/p/1126887/
- KIM itself goes as far back as KDE 3. There is a website that was still functioning in 2025: http://bouveyron.free.fr/kim/index.html
- A huge majority of the code is from the original authors, thanks to them!

## See also
There is a functionally similar but independent project: https://github.com/irfanhakim-as/kde-service-menu-reimage

## Development and translations
For information how to contribute code, translation, documentation etc., see [DEVELOPMENT.md](DEVELOPMENT.md)
