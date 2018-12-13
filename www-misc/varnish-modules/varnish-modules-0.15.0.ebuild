# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Collection of Varnish Cache modules (vmods) by Varnish Software"
HOMEPAGE="https://github.com/varnish/varnish-modules"
SRC_URI="https://github.com/varnish/varnish-modules/archive/${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

src_prepare() {
    # TODO run ./bootstrap
}

src_configure() {
    # TODO econf
}

src_install() {
    # TODO make && make install
}
