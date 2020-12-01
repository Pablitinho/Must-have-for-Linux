#!/bin/bash
#
# Resolve the location of the SmartGit installation.
# This includes resolving any symlinks.
PRG=$0
while [ -h "$PRG" ]; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '^.*-> \(.*\)$' 2>/dev/null`
    if expr "$link" : '^/' 2> /dev/null >/dev/null; then
        PRG="$link"
    else
        PRG="`dirname "$PRG"`/$link"
    fi
done

SMARTGIT_BIN=`dirname "$PRG"`

# absolutize dir
oldpwd=`pwd`
cd "${SMARTGIT_BIN}"
SMARTGIT_BIN=`pwd`
cd "${oldpwd}"
echo "${SMARTGIT_BIN}"
ICON_NAME=pycharm-icon
TMP_DIR=`mktemp --directory`
DESKTOP_FILE=$TMP_DIR/pycharm-desk.desktop
cat << EOF > $DESKTOP_FILE
[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=pycharm
Keywords=pycharm
Comment=pycharm
Type=Application
Categories=Development;RevisionControl
Terminal=false
StartupWMClass=pycharm
Exec="$SMARTGIT_BIN/pycharm.sh" %u
MimeType=x-scheme-handler/python;x-scheme-handler/pycharm;
Icon=$ICON_NAME.png
EOF

# seems necessary to refresh immediately:
chmod 644 $DESKTOP_FILE

xdg-desktop-menu install $DESKTOP_FILE
xdg-icon-resource install --size  128 "$SMARTGIT_BIN/pycharm.png"  $ICON_NAME
#xdg-icon-resource install --size  48 "$SMARTGIT_BIN/pycharm-i.png"  $ICON_NAME
#xdg-icon-resource install --size  64 "$SMARTGIT_BIN/pycharm-i.png"  $ICON_NAME
#xdg-icon-resource install --size 128 "$SMARTGIT_BIN/pycharm-i.png" $ICON_NAME

rm $DESKTOP_FILE
rm -R $TMP_DIR
