#!/usr/bin/bash

set -e

die() {
    echo "${1:-"Unknown error"}" >&2
    exit 255
}

get_esp() {
    esp="$(bootctl -p)" || die "Could not get esp path"
    local esp_devid="$(mountpoint -d "$esp")" || die "Could not get devid of esp"
    local sysfs_path="$(readlink -f "/sys/dev/block/$esp_devid")" || die "Could not get sysfs path of esp"

    esp_part="$(cat "$sysfs_path/partition")" || die "Could not get esp partition number"
    esp_dev="/dev/block/$(cat "$sysfs_path/../dev")" || die "Could not get esp block device"

    echo "Detected ESP partition:"
    echo "  Mountpoint: $esp"
    echo "  Device: $esp_dev"
    echo "  Partition: $esp_part"

    bootloader_dir="$esp/EFI/arch/"
}

create_boot_entry() {
    local path="\\EFI\\ARCH\\$2"
    echo "Creating boot entry: \"$1\" at \"$path\""
    efibootmgr -c \
        -d "$esp_dev" \
        -p "$esp_part" \
        -l "$path" \
        -L "$1" > /dev/null
}

delete_entry() {
    local entry="${1##Boot}"
    entry="${entry%%\*}"
    efibootmgr -b "$entry" -B > /dev/null
}

remove_boot_entry() {
    efibootmgr | grep -i "\\\\EFI\\\\ARCH\\\\$1" | awk '{print $1}' | while read -r entry; do
        delete_entry "$entry"
    done
}

[[ "$1" == "install" ]] && get_esp

while read -r path; do
    package_name="$(pacman -Qoq "$path")" || {
        echo "Could not get package of kernel: $path" >&2
        continue
    }
    case "$1" in
        "install")
            create_boot_entry "$package_name" "$package_name.efi"
            ;;
        "uninstall")
            remove_boot_entry "$package_name.efi"
            ;;
        *)
            die "Invalid operation"
            ;;
    esac
done

exit 0