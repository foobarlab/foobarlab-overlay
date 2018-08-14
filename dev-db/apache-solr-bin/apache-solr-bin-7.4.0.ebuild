# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

MY_PN="solr"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The popular, blazing fast open source enterprise search platform from the Apache Lucene project."
HOMEPAGE="http://lucene.apache.org/solr/"
SRC_URI="mirror://apache/lucene/${MY_PN}/${PV}/${MY_PN}-${PV}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="Apache-2.0"

DEPEND=""
RDEPEND=">=virtual/jre-1.8"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup ${MY_PN} || die "failed to create user group"
	enewuser ${MY_PN} -1 -1 /var/lib/${MY_PN} ${MY_PN} || die "failed to create user"
}

src_install() {
	# FIXME instead of installing to /opt/solr consider installing to /opt/solr-{version} and symlinking from /opt/solr?
	local randpw=$(echo ${RANDOM}|md5sum|cut -c 1-15)
	newinitd "${FILESDIR}/solr.initd" ${MY_PN}-bin
	newconfd "${FILESDIR}/solr.confd" ${MY_PN}-bin
	sed -i "s/solrrocks/${randpw}/g" "${D}/etc/init.d/${MY_PN}-bin" "${D}/etc/conf.d/${MY_PN}-bin"

	# remove files that are not needed on linux
	find \( -name "*.bat" -o -name "*.cmd" \) -delete

	# /etc/solr
	insinto /etc/${MY_PN}/server
	doins -r server/etc/*
	insinto /etc/${MY_PN}
	doins -r server/{contexts,resources}

	# /opt/solr
	insinto /opt/${MY_PN}
	doins -r dist
	dodoc *.txt

	# /opt/solr/bin
	rm -rf bin/init.d/
	exeinto /opt/${MY_PN}/bin
	doexe bin/*
	dosym /opt/${MY_PN}/bin/solr /usr/bin/solr

	# /var/log/solr
	keepdir /var/log/${MY_PN}
	fperms 750 /var/log/${MY_PN}
	fowners solr:solr /var/log/${MY_PN}

	# /opt/solr/server
	insinto /opt/${MY_PN}/server
	doins -r server/{README.txt,start.jar,lib,modules,scripts,solr-webapp}
	dosym /etc/${MY_PN}/server /opt/${MY_PN}/server/etc
	dosym /etc/${MY_PN}/contexts /opt/${MY_PN}/server/contexts
	dosym /etc/${MY_PN}/resources /opt/${MY_PN}/server/resources
	dosym /var/log/${MY_PN} /opt/${MY_PN}/server/logs

	# /var/lib/solr
	insinto /var/lib/${MY_PN}
	doins -r server/solr/*
	fperms 750 /var/lib/${MY_PN}
	fowners solr:solr /var/lib/${MY_PN}

	# remove service installer
	rm "${D}/opt/solr/bin/install_solr_service.sh"

}
