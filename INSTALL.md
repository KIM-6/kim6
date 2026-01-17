## Dependencies

- **KDE Plasma 6**: Dolphin, KDialog and Qt.
- **ImageMagick**: Required for most image operations.
- **FFmpeg**: Required for video conversion; image functions work without it.
- **xdg-email** from `xdg-utils`: Required for the “send by e-mail” action.
- **ExifTool**: Required for metadata stripping.

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
