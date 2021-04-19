# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

EGIT_REPO_URI="https://git.code.sf.net/p/c64-debugger/code" 
EGIT_COMMIT="6d14ae7a5b80435d3fe778af829e6c045d2b72dc"
EGIT_BRANCH="master"

DESCRIPTION="Commodore 64 debugger that works in real time"
HOMEPAGE="https://sourceforge.net/projects/c64-debugger/"
SRC_URI=""

LICENSE="GPL-3+ MIT"
SLOT="0"
KEYWORDS="~*"
IUSE=""

BDEPEND="|| ( >=app-arch/upx-3.94 >=app-arch/upx-bin-3.94 )"

RDEPEND="
    dev-libs/glib:2
    media-libs/alsa-lib
    media-libs/glu
    media-libs/mesa
    x11-libs/gtk+:3
    x11-libs/xcb-util
"

src_prepare() {
    default
    # apply patches for C64 (disables Atari800 and NES), see: https://csdb.dk/release/?id=200432
    eapply "${FILESDIR}/${P}_AtariWrapper.mm.patch"
    eapply "${FILESDIR}/${P}_esc.c.patch"
    eapply "${FILESDIR}/${P}_C64D_Version.h.patch"
}

src_compile() {
    cd "${S}"/MTEngine && emake || die
}

src_install() {
    dobin "${S}/MTEngine/c64debugger"
    dodoc README-SOURCES.txt LICENSE.txt
    # TODO install examples?
}
