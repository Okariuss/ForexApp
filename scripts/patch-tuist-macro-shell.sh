#!/bin/bash
set -eu

PROJECT_FILE="ForexApp.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "error: $PROJECT_FILE not found"
    exit 1
fi

perl -0pi -e 's/(name = "Copy Swift Macro executable into \$BUILT_PRODUCT_DIR";[\s\S]*?shellPath = )\/bin\/sh;/${1}\/bin\/bash;/s' "$PROJECT_FILE"

perl -0pi -e 's/inputPaths = \(\s*(?:"?\$BUILD_DIR\/\$CONFIGURATION\/AppMacrosPlugin"?,\s*)?(?:"?\$OBJROOT\/UninstalledProducts\/macosx\/AppMacrosPlugin"?,\s*)?\);/inputPaths = (\n\t\t\t\t\$BUILD_DIR\/\$CONFIGURATION\/AppMacrosPlugin,\n\t\t\t\t\$OBJROOT\/UninstalledProducts\/macosx\/AppMacrosPlugin,\n\t\t\t);/s' "$PROJECT_FILE"

perl -0pi -e 's/outputPaths = \(\s*(?:"?\$BUILD_DIR\/Debug\$EFFECTIVE_PLATFORM_NAME\/AppMacrosPlugin"?,\s*)?(?:"?\$BUILD_DIR\/Debug-\$EFFECTIVE_PLATFORM_NAME\/AppMacrosPlugin"?,\s*)?\);/outputPaths = (\n\t\t\t\t\$BUILD_DIR\/Debug\$EFFECTIVE_PLATFORM_NAME\/AppMacrosPlugin,\n\t\t\t);/s' "$PROJECT_FILE"

perl -0pi -e 's/shellScript = ".*?";/shellScript = "SOURCE=\\"\$BUILD_DIR\/\$CONFIGURATION\/AppMacrosPlugin\\"\\n\\nif [[ ! -f \\"\$SOURCE\\" ]]; then\\n    SOURCE=\\"\$OBJROOT\/UninstalledProducts\/macosx\/AppMacrosPlugin\\"\\nfi\\n\\nif [[ -f \\"\$SOURCE\\" ]]; then\\n    DESTINATION_DIR=\\"\$BUILD_DIR\/Debug\$EFFECTIVE_PLATFORM_NAME\\"\\n    DESTINATION=\\"\$DESTINATION_DIR\/AppMacrosPlugin\\"\\n\\n    mkdir -p \\"\$DESTINATION_DIR\\"\\n    rm -f \\"\$DESTINATION\\"\\n    ln -s \\"\$SOURCE\\" \\"\$DESTINATION\\"\\nfi\\n";/s' "$PROJECT_FILE"

if ! grep -A 24 -B 8 "Copy Swift Macro executable" "$PROJECT_FILE" | grep -q "shellPath = /bin/bash;"; then
    echo "error: failed to patch Swift macro copy script shell"
    exit 1
fi

if ! grep -A 40 -B 8 "Copy Swift Macro executable" "$PROJECT_FILE" | grep -q "\$BUILD_DIR/\$CONFIGURATION/AppMacrosPlugin"; then
    echo "error: failed to patch Swift macro copy script input paths"
    exit 1
fi

if ! grep -A 40 -B 8 "Copy Swift Macro executable" "$PROJECT_FILE" | grep -q "ln -s"; then
    echo "error: failed to patch Swift macro copy script body"
    exit 1
fi

echo "Patched Swift macro copy phase"
