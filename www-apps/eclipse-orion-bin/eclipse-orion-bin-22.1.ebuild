# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

MY_PN="orion"
MY_P="${MY_PN}-${PV}"
DMF="R-${PV}-202005041748"

#https://download.eclipse.org/orion/drops/R-22.1-202005041748/download.php?dropFile=eclipse-orion-22.0.0S1-linux.gtk.x86_64.zip
#https://download.eclipse.org/orion/drops/R-22.1-202005041748/eclipse-orion-22.0.0S1-linux.gtk.x86_64.zip

DESCRIPTION="The Eclipse Orion Project's objective is to create a browser-based open tool integration platform which is entirely focused on developing for the web, in the web."
HOMEPAGE="https://projects.eclipse.org/projects/ecd.orion"
SRC_URI="https://download.eclipse.org/orion/drops/${DMF}/eclipse-orion-22.0.0S1-linux.gtk.x86_64.zip"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="EPL-2.0"

DEPEND=""
RDEPEND=">=virtual/jre-1.8"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup ${MY_PN} || die "failed to create user group"
	enewuser ${MY_PN} -1 -1 /var/lib/${MY_PN} ${MY_PN} || die "failed to create user"
}

src_install() {

	#local randpw=$(echo ${RANDOM}|md5sum|cut -c 1-15)
	newinitd "${FILESDIR}/orion.initd" ${MY_PN}
	newconfd "${FILESDIR}/orion.confd" ${MY_PN}
	#sed -i "s/solrrocks/${randpw}/g" "${D}/etc/init.d/${MY_PN}" "${D}/etc/conf.d/${MY_PN}"

	# remove files that are not needed on linux
	find \( -name "*.bat" -o -name "*.cmd" \) -delete

	# /etc/orion
	#insinto /etc/${MY_PN}/server
	#doins -r server/etc/*
	#insinto /etc/${MY_PN}
	#doins -r server/{contexts,resources}

	# /opt/orion
	#insinto /opt/${MY_PN}
	#doins -r {dist,contrib,example,licenses}
	#dodoc *.txt

	# /opt/orion/bin
	#exeinto /opt/${MY_PN}/bin
	#rm -rf bin/init.d/
	#rm bin/install_solr_service.sh
	#doexe bin/*
	#dosym /opt/${MY_PN}/bin/solr /usr/bin/solr

	# /var/log/orion
	keepdir /var/log/${MY_PN}
	fperms 750 /var/log/${MY_PN}
	fowners ${MY_PN}:${MY_PN} /var/log/${MY_PN}

	# /opt/solr/server
	#insinto /opt/${MY_PN}/server
	#doins -r server/{README.txt,start.jar,lib,modules,scripts,solr-webapp}
	#dosym /etc/${MY_PN}/server /opt/${MY_PN}/server/etc
	#dosym /etc/${MY_PN}/contexts /opt/${MY_PN}/server/contexts
	#dosym /etc/${MY_PN}/resources /opt/${MY_PN}/server/resources
	#dosym /var/log/${MY_PN} /opt/${MY_PN}/server/logs
	#dosym /var/lib/${MY_PN} /opt/${MY_PN}/server/solr

    # /opt/solr/server/scripts/cloud-scripts
    #fperms 750 /opt/${MY_PN}/server/scripts/cloud-scripts/snapshotscli.sh
	#fperms 750 /opt/${MY_PN}/server/scripts/cloud-scripts/zkcli.sh

	# /var/lib/solr
	#insinto /var/lib/${MY_PN}
	#doins -r server/solr/*
	#fperms 750 /var/lib/${MY_PN}
	#fowners solr:solr /var/lib/${MY_PN}
}
