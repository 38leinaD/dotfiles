#!/bin/bash
set -e

# Usage: install-intellij-idea.sh [--no-skill]
# By default the ij-debugger Copilot skill bundled with IDEA is (over)written too.
INSTALL_SKILL=1
for arg in "$@"; do
	case "$arg" in
		--no-skill) INSTALL_SKILL=0 ;;
		*) echo "Unknown option: $arg" >&2; exit 1 ;;
	esac
done

sudo echo

IDEA_DOWNLOAD_LINK=$(curl https://data.services.jetbrains.com/products\?code\=IIU\&release.type\=release\&fields\=distributions%2Clink%2Cname%2Creleases | jq -r '.[0].releases[0].downloads.linux.link')

IDEA_TAR=$(echo $IDEA_DOWNLOAD_LINK | rev | cut -d / -f1 | rev)

if [ ! -e ~/Downloads/$IDEA_TAR ]; then
	pushd ~/Downloads
	curl -LO $IDEA_DOWNLOAD_LINK
	popd
fi

TMP=$(mktemp -d)
echo "Using temporary directory $TMP"

tar -xzf ~/Downloads/$IDEA_TAR -C $TMP
IDEA_DIR=$(ls $TMP)
sudo mv $TMP/$IDEA_DIR /opt/
sudo rm -f /usr/local/bin/idea
sudo ln -s /opt/$IDEA_DIR/bin/idea.sh /usr/local/bin/idea

mkdir -p ~/.local/share/applications
cat > ~/.local/share/applications/intellij-idea.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA Ultimate
Icon=/opt/$IDEA_DIR/bin/idea.svg
Exec="/opt/$IDEA_DIR/bin/idea" %f
Comment=Capable and Ergonomic IDE for JVM
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-idea
StartupNotify=true
EOF

update-desktop-database ~/.local/share/applications 2>/dev/null || true

if [ "$INSTALL_SKILL" = 1 ]; then
	# Extract the ij-debugger skill (debuggerMcp plugin) and install it as a Copilot skill
	JAR="/opt/$IDEA_DIR/plugins/debuggerMcp/lib/debuggerMcp.jar"
	SKILL_DEST="$HOME/.copilot/skills/ij-debugger"
	if [ -f "$JAR" ]; then
		SKILL_TMP=$(mktemp -d)
		unzip -oq "$JAR" ij-debugger-skill.md -d "$SKILL_TMP"
		mkdir -p "$SKILL_DEST"
		cp "$SKILL_TMP/ij-debugger-skill.md" "$SKILL_DEST/SKILL.md"
		rm -rf "$SKILL_TMP"
		echo "Installed $SKILL_DEST/SKILL.md (from $JAR)"
	else
		echo "debuggerMcp.jar not found at: $JAR; skipping skill" >&2
	fi
fi
