# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="An Optimizing Hybrid LZ77 RLE Data Compression Program"
HOMEPAGE="http://a1bert.kapsi.fi/Dev/pucrunch/"
SRC_URI="http://a1bert.kapsi.fi/Dev/pucrunch/Makefile
    http://a1bert.kapsi.fi/Dev/pucrunch/pucrunch.h
    http://a1bert.kapsi.fi/Dev/pucrunch/pucrunch.c
    http://a1bert.kapsi.fi/Dev/pucrunch/index.html -> pucrunch.html
    http://a1bert.kapsi.fi/Dev/pucrunch/cbmcombine.c
"

# TODO download examples?
# http://a1bert.kapsi.fi/Dev/pucrunch/uncrunch.asm
# http://a1bert.kapsi.fi/Dev/pucrunch/sa_uncrunch.asm
# http://a1bert.kapsi.fi/Dev/pucrunch/uncrunch-z80.asm

# TODO download man pages from slackbuild? (https://slackbuilds.org/repository/14.2/system/pucrunch/) 

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~*"
IUSE=""

src_unpack() {
    mkdir ${WORKDIR}/${P} || die
    cp ${DISTDIR}/Makefile ${S} || die
    cp ${DISTDIR}/pucrunch.h ${S} || die
    cp ${DISTDIR}/pucrunch.c ${S} || die
    cp ${DISTDIR}/pucrunch.html ${S} || die
    cp ${DISTDIR}/cbmcombine.c ${S} || die
}

src_prepare() {
    default
    sed -i "s,-O,-O2 -fPIC," ${S}/Makefile
}

src_compile() {
    make || die
    gcc -O2 -fPIC -funsigned-char -include sys/param.h -Dfar= -Dmin=MIN -Dmax=MAX -o cbmcombine cbmcombine.c || die
}

src_install() {
    dobin pucrunch
    dobin cbmcombine
    dodoc pucrunch.html
    # TODO put examples into /usr/share/doc/pucrunch-22.11.2008/examples/... ?
    #dodoc uncrunch.asm
    #dodoc sa_uncrunch.asm
    #dodoc uncrunch-z80.asm
}
