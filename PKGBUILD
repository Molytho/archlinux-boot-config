pkgbase=boot-config
pkgname=(
    boot-config-common
    boot-config-sd-boot
    boot-config-efi
)
pkgver=0.1.1
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
    kernel-install.sh
    sd-boot-install.sh
    install.conf
    uki.conf
    boot-config.install
    boot-config-sd-boot.install
)
sha256sums=('3ba376c10e04cc0e3665a7f70e0a4c78b83eda0a0d99c05bf932e39ab999d8c1'
            '7dace1b7faaf462b52cda929110e21f61207c45bb5239ea0e4b641a1a85e75cc'
            '46af0e7ed593b3a9f307f7cb8c4a1f6b833eedd4f01f7b6147dc6c10b7290c6c'
            '10dacba69915d6eb1cc57558d630fe8886ade88b0f2bd2302d8937c803f61a66'
            'd8bc81d7590e3894c3727aee25f061838e1ecfb5c97519e106f808688bd1c2f3'
            'e21574eef4042dc2d81a349e53ea2b79e28a358bf21a46399b3932ecfab74a23'
            '597ef468a2d01da5b9f66877eb3f5b08c66e97c8ef7fec4f7a4e9d3f778eb6a2'
            '2b75fece61d71f4908af13d8815b15f75f87463b4d582d19fc4c69b2b13e4b50'
            '1acebe38cd460afdbc8fcc3acf38a2ece34513ea81213ed191250b890b12c6b2'
            'dd8d010b5d09400f33464d7fccd672fd13c7327cf3904c56151f324f181d2674'
            '4bb34fdaa3c2b264eda1ba23beee1b5f8ccf1ae3e70e89062b7c3babae5f900a'
            '8591a0157eb281772e14783b77285e6802741e0893a9e5b8ad86392655e157d8')

package_boot-config-common() {
    depends=(systemd systemd-ukify mkinitcpio sbsigntools)
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
    depends=(boot-config-common shim-signed efibootmgr)
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
}
