pkgbase=boot-config
pkgname=(
    boot-config-common
    boot-config-sd-boot
    boot-config-efi
)
pkgver=0.1
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
    install.conf
    uki.conf
    boot-config.install
    boot-config-sd-boot.install
)
sha256sums=('3a198aaf129c4b18a389d87820d1dd9661b66534b7a83e7d14be503e73a836b6'
            '8c5b8f2f666633d0d5eb27bc9cae80da1033aeb6ab9645c4ed13cec95c690951'
            '57df38645adab4952d400b56144d80206a6fb660de163b43b259e9019db4ab85'
            'd474d0eb45c8da5b5a61725655da137b23cbb2cf1988bfa008776a9a411f44f5'
            '072ed527044116afa8583794fdbd97a31950cd995d655149b6b7523982f238c9'
            '3daa622d9ef9679169f4773797efa35dc1d991f048fba88b816b18e4eaf17dcf'
            '597ef468a2d01da5b9f66877eb3f5b08c66e97c8ef7fec4f7a4e9d3f778eb6a2'
            '1acebe38cd460afdbc8fcc3acf38a2ece34513ea81213ed191250b890b12c6b2'
            'dd8d010b5d09400f33464d7fccd672fd13c7327cf3904c56151f324f181d2674'
            '4bb34fdaa3c2b264eda1ba23beee1b5f8ccf1ae3e70e89062b7c3babae5f900a'
            '14ebd3d6d4e93290fb77b0f1170487ffa929b66403db3fec6660caaa5b775bd7')

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

    install -Dm755 'kernel-install.sh' "${pkgdir}/usr/share/libalpm/scripts/kernel-install"

    ln -s /dev/null "${pkgdir}/etc/pacman.d/hooks/60-mkinitcpio-remove.hook"
    ln -s /dev/null "${pkgdir}/etc/pacman.d/hooks/90-mkinitcpio-install.hook"
}

package_boot-config-sd-boot() {
    depends=(boot-config-common shim-signed)
    install=boot-config-sd-boot.install

    cd "${srcdir}"

    install -d "${pkgdir}/etc/pacman.d/hooks/"
    install -m 444 -t "${pkgdir}/etc/pacman.d/hooks/" \
        60-sd-boot-remove.hook \
        90-sd-boot-install.hook \
        60-shim-remove.hook \
        90-shim-install.hook
}

package_boot-config-efi() {
    depends=(boot-config-common)
}
