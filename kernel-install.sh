#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit nullglob

operation="$1"

all_kernels=0
declare -A versions

add_file() {
	local kver="$1"
	kver="${kver##usr/lib/modules/}"
	kver="${kver%%/*}"
	versions["$kver"]=""
}


while read -r target; do
	case "$target" in
	usr/lib/modules/*/vmlinuz)
		add_file "$target"
		;;
	*)
		all_kernels=1
		;;
	esac
done


if ((all_kernels)) && [ "$operation" == "add" ]; then
	kernel-install add-all || true
	exit 0
fi


((all_kernels)) && for file in usr/lib/modules/*/vmlinuz; do
	add_file "$file"
done

for kver in "${!versions[@]}"; do
	kernel-install "$operation" "$kver" "/usr/lib/modules/$kver/vmlinuz" || true
done
