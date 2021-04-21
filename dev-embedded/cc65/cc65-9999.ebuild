# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cc65/cc65.git"
else
    SRC_URI="https://github.com/cc65/cc65/archive/V${PV}.tar.gz  -> ${P}.tar.gz"
    KEYWORDS="~amd64"
fi

DESCRIPTION="A freeware C compiler for 6502-based systems"
HOMEPAGE="https://cc65.github.io/"
LICENSE="ZLIB"
SLOT="0"
IUSE="doc"

DEPEND="doc? ( app-text/linuxdoc-tools )"

src_compile() {
	PREFIX=/usr emake
	use doc && emake -C doc
}

src_install() {
	DESTDIR="${D}" PREFIX="/usr" emake install
}
