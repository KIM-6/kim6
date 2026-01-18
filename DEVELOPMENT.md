# Developer and translator information

## Translations
To submit a new translation, run `msginit -l XX` in the `po` directory (replace "XX" with the shortcut of your language) and translate the strings there.
To change a current translation, edit the [po files](https://github.com/KIM-6/kim6/tree/master/po).
In either case, open an [issue](https://github.com/KIM-6/kim6/issues/new) with the resulting file as an attachment. Even better, create a pull request.

To test your translation, install it (see [INSTALL.md](/INSTALL.md#option-3-install-from-a-cloned-repository), option 3) and run Dolphin like this (replace your language for "nl"):
```
LANGUAGE=nl dolphin
```

To generate new `.pot` template and update the individual translations, one runs this in the project root directory (it actually runs in the `po` directory; unless you develop a new feature, you should not need this, the translations are kept mostly up to date):
```
VERSION=$(grep -m 1 "^Release" ChangeLog | grep -oP '\d+\.\d+\.\d+') # set kim6 version
cd po;
# this creates a new pot file from the files in the bin directory (do not update because then deleted strings are kept)
xgettext --language=Shell --keyword=gettext --output=kim6.pot --from-code=UTF-8 --add-comments=TRANSLATORS --package-name="KIM 6 — Kde Image Menu 6" --package-version="$VERSION" --msgid-bugs-address="https://github.com/KIM-6/kim6/issues" ../src/bin/kim_*

# this gets strings from the desktop.in files, one needs to first extract the strings before gettext can recognize them, that creates header files and so comments about string locations are then wrong in the po and pot files
for desk_ini in ../src/*.desktop.in;
do intltool-extract --type=gettext/ini "$desk_ini";
xgettext --keyword=N_:1 --join-existing --output kim6.pot --from-code=UTF-8 --package-name="KIM 6 — Kde Image Menu 6" --package-version="$VERSION" --msgid-bugs-address="https://github.com/KIM-6/kim6/issues" "$desk_ini".h;

# the header files are just temporary
rm "$desk_ini".h;
done;

# % in the strings causes gettext to include this warning that we get rid of
grep -v '^#, no-c-format' kim6.pot > temp.pot;
mv temp.pot kim6.pot;

# with the resulting pot file, we can update the po files in case there are new strings or some got deleted
for po in *.po; do msgmerge --update "$po" kim6.pot;
done
cd ..
```

## Release

First update the **changelog** (keep format!), then the translations (**do not forget to commit them!**) and then run the following in the project root directory (you need to have `gh` installed):
```
VERSION=$(grep -m 1 "^Release" ChangeLog | grep -oP '\d+\.\d+\.\d+') # set kim6 version


# generate desktop files
cd po;
for desk_ini in ../src/*.desktop.in; do intltool-merge --desktop-style ./ "$desk_ini"  "${desk_ini%.in}"; chmod +x "${desk_ini%.in}" ; done
cd ..;

# Do not include files that need not be installed (we first need to create the archive so tar does not complain about file being changed as it is read)
touch kim6_$VERSION.tar.gz
tar -czf kim6_$VERSION.tar.gz --exclude=README.md  --exclude=KIM6.png --exclude=Changelog --exclude kim6_$VERSION.tar.gz --exclude kim6_*.tar.gz --exclude './src/*desktop.in' --exclude ./.* ./

# generated desktop files are no longer needed
rm src/kim_compressandresize.desktop src/kim_compressandresizevideo.desktop src/kim_convertandrotate.desktop src/kim_publication.desktop
NOTES=$(sed -n '/^Release/,/^$/p' ChangeLog | grep '^-' | head -n -1)
gh release create "v$VERSION" --title "Version $VERSION" --notes "$NOTES" ./kim6*.tar.gz
```

The archive is automatically uploaded to Github and a release and a new verison tag is made here. Then manually upload it to https://store.kde.org/p/2307290/ (you can delete the tar file after).

## Development

Try to make a release (see above) and then test your changes with:
```
servicemenuinstaller install kim6_$VERSION.tar.gz
```
Then clean up with:
```
servicemenuinstaller uninstall kim6_$VERSION.tar.gz
```

It is also possible to run the `.install.sh` and `.uninstall.sh` scripts, the desktop files will be generated automatically.

Individual scripts can also be run directly. Look into the bin files (which are bash scripts in `src/bin` folder) to see what arguments they need. For example this resizes proportionally a given file 300 pixels along its shorter side:
```
./kim_resize ~/example.jpg 300x300
```

## Todo

- Functionally, KIM 6 is stable. Please report bugs if you find any.
- Technically, it would be good to merge executable files and refactor common code in functions, that should reduce the code size by half. Patches welcome!
