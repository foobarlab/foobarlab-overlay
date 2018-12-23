# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

MY_PN="etherpad-lite"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Etherpad is a highly customizable Open Source online editor providing collaborative editing in really real-time"
HOMEPAGE="http://etherpad.org/"
SRC_URI="https://github.com/ether/etherpad-lite/archive/${PV}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="Apache-2.0"
# TODO other IUSE flags could be: abiword soffice tidy doc ssl webapp-config nodejs
IUSE="mysql"

RDEPEND="
    >=net-libs/nodejs-6.9.0[npm]
    net-misc/curl
"
DEPEND="${RDEPEND}"

RESTRICT=test

S=${WORKDIR}/${MY_P}

pkg_setup() {
    enewgroup ${MY_PN} || die "failed to create user group"
    enewuser ${MY_PN} -1 -1 /var/lib/${MY_PN} ${MY_PN} || die "failed to create user"
}

src_compile() {
    emake docs
    # TODO node install is maintained by bin/installDeps.sh (invoked by run.sh)
    #npm install --no-save --loglevel-warn
    # TODO evaluate if isolated nodejs env makes sense
}

src_install() {
    # TODO copy necessary files to /var/lib/etherpad-lite dir ...
    newinitd "${FILESDIR}/etherpad-lite.initd" ${MY_PN}
    newconfd "${FILESDIR}/etherpad-lite.confd" ${MY_PN}
    # TODO settings.json
    # TODO generate new APIKEY.txt and SESSIONKEY.txt
}
