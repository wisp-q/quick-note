#!/bin/bash
set -e

echo "Installing QuickNote Plugin..."

mkdir -p build 
cd build
cmake ..
cmake --build .
cd ..

echo "Copying QML and C++ plugin files...."
LOCAL_PLUGIN_DIR="$HOME/.config/omarchy/plugins/my.quicknote"

mkdir -p "$LOCAL_PLUGIN_DIR/My/QuickNote"
chmod 700 "$LOCAL_PLUGIN_DIR"
chmod 700 "$LOCAL_PLUGIN_DIR/My"
chmod 700 "$LOCAL_PLUGIN_DIR/My/QuickNote"

rm -f "$LOCAL_PLUGIN_DIR/.repo_path"
echo "$PWD" > "$LOCAL_PLUGIN_DIR/.repo_path"

rm -rf "$LOCAL_PLUGIN_DIR/plugin"
cp plugin/*.qml "$LOCAL_PLUGIN_DIR/"
sed -i "s|@@PLUGIN_DIR@@|$LOCAL_PLUGIN_DIR|g" "$LOCAL_PLUGIN_DIR"/*.qml

rm -f "$LOCAL_PLUGIN_DIR/manifest.json"
cp manifest.json "$LOCAL_PLUGIN_DIR/"

# Copy QML module and binary plugin libraries
cp -f build/My/QuickNote/libquicknoteplugin.so "$LOCAL_PLUGIN_DIR/My/QuickNote/"
if [ -f build/My/QuickNote/libquicknote.so ]; then
    cp -f build/My/QuickNote/libquicknote.so "$LOCAL_PLUGIN_DIR/My/QuickNote/"
elif [ -f build/libquicknote.so ]; then
    cp -f build/libquicknote.so "$LOCAL_PLUGIN_DIR/My/QuickNote/"
fi
cp -f build/My/QuickNote/qmldir "$LOCAL_PLUGIN_DIR/My/QuickNote/"
if [ -f build/My/QuickNote/quicknote.qmltypes ]; then
    cp -f build/My/QuickNote/quicknote.qmltypes "$LOCAL_PLUGIN_DIR/My/QuickNote/"
fi

echo "Reloading shell plugins..."
omarchy-shell shell rescanPlugins 2>/dev/null || true
omarchy plugin enable my.quicknote 2>/dev/null || true

echo "Done!"
