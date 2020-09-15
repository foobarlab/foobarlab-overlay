# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

MY_PN="orion"
DMF="R-${PV}-202005041748"

DESCRIPTION="The Eclipse Orion Project's objective is to create a browser-based open tool \
integration platform which is entirely focused on developing for the web, in the web."
HOMEPAGE="https://projects.eclipse.org/projects/ecd.orion"
SRC_URI="https://download.eclipse.org/orion/drops/${DMF}/eclipse-orion-22.0.0S1-linux.gtk.x86_64.zip"

KEYWORDS="~amd64"
SLOT="0"
LICENSE="EPL-2.0"

DEPEND=""
RDEPEND=">=virtual/jre-1.8"

S=${WORKDIR}/eclipse

src_install() {

	# /opt/orion
	doexe orion
	insinto /opt/${MY_PN}
	doins -r *
	dosym /opt/${MY_PN}/orion /usr/bin/orion

	# /var/log/orion
	keepdir /var/log/${MY_PN}
	fperms 750 /var/log/${MY_PN}
	fowners ${MY_PN}:${MY_PN} /var/log/${MY_PN}
}
