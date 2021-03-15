#!/usr/bin/env bash

package_opk() {
	local ext
	if [[ $TARGET == rg350 ]] || [[ $TARGET == gkd350h ]]; then
		ext=gcw0
	else
		ext="$TARGET"
	fi
	local -r tmp="${BUILD_DIR}/opk"
	set -x
	rm -rf "$tmp"
	mkdir -p "$tmp"

	if [[ $HELLFIRE == ON ]]; then
		cp "Packaging/OpenDingux/${TARGET}-hellfire.desktop" "${tmp}/default.${ext}.desktop"
		SUFFIX="-hellfire"
	else
		cp "Packaging/OpenDingux/${TARGET}.desktop" "${tmp}/default.${ext}.desktop"
		SUFFIX=""
	fi

	cp "Packaging/OpenDingux/${TARGET}-manual.txt" "${tmp}/readme.${ext}.txt"
	mksquashfs "${BUILD_DIR}/devilutionx" \
		"${tmp}/default.${ext}.desktop" \
		"${tmp}/readme.${ext}.txt" Packaging/resources/icon_32.png \
		Packaging/resources/hellfire_32.png Packaging/resources/CharisSILB.ttf \
		Packaging/resources/devilutionx.mpq \
		"${BUILD_DIR}/devilutionx-${TARGET}${SUFFIX}.opk" \
		-all-root -no-xattrs -noappend -no-exports -no-progress
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	set -euo pipefail

	cd "$(dirname "${BASH_SOURCE[0]}")/../.."

	source Packaging/OpenDingux/targets.sh

	usage() {
		echo "Usage: package-opk.sh [target]"
		usage_target
	}

	if ! check_target "$@"; then
		usage
		exit 64
	fi

	declare -r TARGET="$1"
	declare -r BUILD_DIR="build-${TARGET}"
	package_opk
fi
