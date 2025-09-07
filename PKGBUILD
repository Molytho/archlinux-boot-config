pkgbase=boot-config
pkgname=(
    boot-config-common
    boot-config-sd-boot
    boot-config-efi
)
pkgver=0.1.5
pkgrel=1
pkgdesc="EFI uki boot setup"
arch=(x86_64)
license=(GPL-3.0-or-later)
makedepends=()
source=(
    60-kernel-install-remove.hook
    90-kernel-install-install.hook
    60-sd-boot-remove.hook
    90-sd-boot-install.hook
    60-shim-remove.hook
    90-shim-install.hook
    60-efi-install-remove.hook
    90-efi-install-install.hook
    kernel-install.sh
    sd-boot-install.sh
    efi-install.sh
    90-uki-copy.install
    install.conf
    uki.conf
    boot-config.install
    boot-config-sd-boot.install
    boot-config-efi.install
)
sha256sums=('3ba376c10e04cc0e3665a7f70e0a4c78b83eda0a0d99c05bf932e39ab999d8c1'
            '7dace1b7faaf462b52cda929110e21f61207c45bb5239ea0e4b641a1a85e75cc'
            '46af0e7ed593b3a9f307f7cb8c4a1f6b833eedd4f01f7b6147dc6c10b7290c6c'
            '10dacba69915d6eb1cc57558d630fe8886ade88b0f2bd2302d8937c803f61a66'
            'd8bc81d7590e3894c3727aee25f061838e1ecfb5c97519e106f808688bd1c2f3'
            'e21574eef4042dc2d81a349e53ea2b79e28a358bf21a46399b3932ecfab74a23'
            'a57e6c288dc7c15c41d39d4738804b0d9d03e2a078e2fec291fe27f2f13432fc'
            '9718494fb88cf5663f160b4de6d3c316b3c46a66b5b110e3c79c35dbcf994e29'
            '597ef468a2d01da5b9f66877eb3f5b08c66e97c8ef7fec4f7a4e9d3f778eb6a2'
            '778fe50122be109105f8a90fddf48b4e47891251a239c0c2846e6b37d7a56ce0'
            '5d6b0dce5b56eb79a35384edf924b0028f604a6413143a318011103d45a88e40'
            '3bada5f0ffa5f25504707bd80c49743fb67efc34ea497de0665b5971a45177f0'
            '1acebe38cd460afdbc8fcc3acf38a2ece34513ea81213ed191250b890b12c6b2'
            'eaf2738a2c162500635b07024b0cf3a532377fcfa13dc198a30f3754a9e2bd1e'
            '8d5be63f80fffb6b5ded2dbee25695d202ce1a622a96732bb51e7274a37f8239'
            '8591a0157eb281772e14783b77285e6802741e0893a9e5b8ad86392655e157d8'
            '664a17f0cdd41aeff759809448a8c1e4510b1b83c94605b1e72b89b55be69855')

package_boot-config-common() {
    depends=(systemd systemd-ukify mkinitcpio sbsigntools openssl)
    backup=(etc/kernel/cmdline)
    install=boot-config.install

    cd "${srcdir}"

    install -d "${pkgdir}/etc/kernel/"
    install -m 444 -t "${pkgdir}/etc/kernel/" \
        install.conf \
        uki.conf
    touch "${pkgdir}/etc/kernel/cmdline"

    install -d "${pkgdir}/etc/pacman.d/hooks/"
    install -m 444 -t "${pkgdir}/etc/pacman.d/hooks/" \
        60-kernel-install-remove.hook \
        90-kernel-install-install.hook
    ln -s /dev/null "${pkgdir}/etc/pacman.d/hooks/60-mkinitcpio-remove.hook"
    ln -s /dev/null "${pkgdir}/etc/pacman.d/hooks/90-mkinitcpio-install.hook"

    install -Dm755 'kernel-install.sh' "${pkgdir}/usr/lib/boot-config/kernel-install"
}

package_boot-config-sd-boot() {
    depends=(boot-config-common shim-signed efibootmgr mokutil)
    conflicts=(boot-config-efi)
    install=boot-config-sd-boot.install

    cd "${srcdir}"

    install -d "${pkgdir}/etc/pacman.d/hooks/"
    install -m 444 -t "${pkgdir}/etc/pacman.d/hooks/" \
        60-sd-boot-remove.hook \
        90-sd-boot-install.hook \
        60-shim-remove.hook \
        90-shim-install.hook

    install -Dm755 'sd-boot-install.sh' "${pkgdir}/usr/lib/boot-config/sd-boot-install"
}

package_boot-config-efi() {
    depends=(boot-config-common)
    conflicts=(boot-config-sd-boot)
    install=boot-config-efi.install

    cd "${srcdir}"

    install -d "${pkgdir}/etc/kernel/install.d/"
    install -m 755 -t "${pkgdir}/etc/kernel/install.d/" \
        90-uki-copy.install

    install -d "${pkgdir}/etc/pacman.d/hooks/"
    install -m 444 -t "${pkgdir}/etc/pacman.d/hooks/" \
        60-efi-install-remove.hook \
        90-efi-install-install.hook

    install -Dm755 'efi-install.sh' "${pkgdir}/usr/lib/boot-config/efi-install"
}
