# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
﻿
#inherit autotools

DESCRIPTION="Collection of Varnish Cache modules (vmods) by Varnish Software"
HOMEPAGE="https://github.com/varnish/varnish-modules"
SRC_URI="https://github.com/varnish/varnish-modules/archive/${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
    bootstrap
}

src_configure() {
    if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
        econf
    fi
}

src_compile() {
    if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ] ; then
        emake || die "emake failed"
    fi
}

src_install() {
    # TODO make install
}
