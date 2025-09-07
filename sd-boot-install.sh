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

install_shim() {
    mkdir -p "$bootloader_dir"

    echo "Installing shim..."
    install -t "$bootloader_dir" \
        /usr/share/shim-signed/shimx64.efi \
        /usr/share/shim-signed/mmx64.efi
}

install_sd_boot() {
    mkdir -p "$bootloader_dir"

    echo "Installing systemd-boot..."
    sbsign \
        --key /etc/kernel/mok.key \
        --cert /etc/kernel/mok.crt \
        --output "$bootloader_dir/grubx64.efi" \
        /usr/lib/systemd/boot/efi/systemd-bootx64.efi
}

create_boot_entry() {
    echo "Creating boot entry..."
    efibootmgr -c \
        -d "$esp_dev" \
        -p "$esp_part" \
        -l "\EFI\ARCH\SHIMX64.EFI" \
        -L "systemd-boot" > /dev/null
}

install-all() {
    install_shim
    install_sd_boot
    create_boot_entry
}

uninstall_shim() {
    echo "Uninstalling shim..."
    rm -f /efi/EFI/arch/shimx64.efi /efi/EFI/arch/mmx64.efi
}

uninstall_sd_boot() {
    echo "Uninstalling systemd-boot..."
    rm -f /efi/EFI/arch/grubx64.efi
}

uninstall-all() {
    uninstall_shim
    uninstall_sd_boot
}

get_esp
case "$1" in
    "install")
        install-all
        ;;
    "install-sd-boot")
        install_sd_boot
        ;;
    "install-shim")
        install_shim
        ;;
    "uninstall")
        uninstall-all
        ;;
    "uninstall-sd-boot")
        uninstall_sd_boot
        ;;
    "uninstall-shim")
        uninstall_shim
        ;;
    "create-boot-entry")
        create_boot_entry
        ;;
    *)
        die "Invalid operation"
        ;;
esac

exit 0