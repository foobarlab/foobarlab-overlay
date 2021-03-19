# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Collection of Varnish Cache modules (vmods) by Varnish Software"
HOMEPAGE="https://github.com/varnish/varnish-modules"
SRC_URI="https://github.com/varnish/varnish-modules/archive/varnish-modules-${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="=www-servers/varnish-6.5.0"
DEPEND="${RDEPEND}"

src_prepare() {
    eapply_user
    ${S}/bootstrap
}
