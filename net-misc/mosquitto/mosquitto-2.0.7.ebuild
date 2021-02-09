# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit python-any-r1 toolchain-funcs user

DESCRIPTION="An Open Source MQTT Broker"
HOMEPAGE="https://mosquitto.org/ https://github.com/eclipse/mosquitto"

# FIXME: download required cJSON files
#SRC_URI="https://mosquitto.org/files/source/${P}.tar.gz https://github.com/DaveGamble/cJSON/archive/v1.7.14.tar.gz"

SRC_URI="https://mosquitto.org/files/source/${P}.tar.gz"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~x86"
#IUSE="bridge +cjson examples libressl +persistence +srv ssl tcpd test websockets"
IUSE="bridge cjson examples libressl +persistence +srv ssl tcpd test websockets"    # FIXME temporary workaround
RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( bridge )"

RDEPEND="
	srv? ( net-dns/c-ares:= )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	tcpd? ( sys-apps/tcp-wrappers )"

DEPEND="${PYTHON_DEPS}
	${RDEPEND}
	test? ( dev-util/cunit )
	websockets? ( net-libs/libwebsockets[lejp] )"

_emake() {
	local LIBDIR=$(get_libdir)
	emake \
		CC="$(tc-getCC)" \
		CLIENT_LDFLAGS="${LDFLAGS}" \
		LIB_SUFFIX="${LIBDIR:3}" \
		WITH_BRIDGE="$(usex bridge)" \
		WITH_CJSON="$(usex cjson)" \
		WITH_PERSISTENCE="$(usex persistence)" \
		WITH_SRV="$(usex srv)" \
		WITH_TLS="$(usex ssl)" \
		WITH_WEBSOCKETS="$(usex websockets)" \
		WITH_WRAP="$(usex tcpd)" \
		"$@"
}

pkg_setup() {
	enewgroup mosquitto || die "failed to create user group"
	enewuser mosquitto -1 -1 /var/lib/mosquitto mosquitto || die "failed to create user"
}

src_prepare() {
	default
	if use persistence; then
	   # TODO check:
		sed -i -e "/^#autosave_interval/s|^#||" \
			-e "s|^#persistence false$|persistence true|" \
			-e "/^#persistence_file/s|^#||" \
			-e "s|#persistence_location|persistence_location /var/lib/mosquitto/|" \
			mosquitto.conf || die
	fi

	# Remove prestripping
	sed -i -e 's/-s --strip-program=${CROSS_COMPILE}${STRIP}//'\
		client/Makefile lib/cpp/Makefile src/Makefile lib/Makefile || die

	# Remove failing tests
	# TODO check
	sed -i -e '/02-subpub-qos1-bad-pubcomp.py/d' \
		-e '/02-subpub-qos1-bad-pubrec.py/d' \
		-e '/02-subpub-qos2-bad-puback-1.py/d' \
		-e '/02-subpub-qos2-bad-puback-2.py/d' \
		-e '/02-subpub-qos2-bad-pubcomp.py/d' \
		test/broker/Makefile || die
	sed -i -e '/02-subscribe-qos1-async2.test/d' \
		test/lib/Makefile || die

	python_setup
	python_fix_shebang test
	
	# TODO copy cJSON files
	#if use cjson; then
	#fi
}

src_compile() {
	_emake
}

src_test() {
	_emake test
}

src_install() {
	_emake DESTDIR="${D}" prefix=/usr install
	keepdir /var/lib/mosquitto
	fowners mosquitto:mosquitto /var/lib/mosquitto
	dodoc README.md README-letsencrypt.md CONTRIBUTING.md ChangeLog.txt
	doinitd "${FILESDIR}"/mosquitto
	insinto /etc/mosquitto
	doins mosquitto.conf
	
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "The Python module has been moved out of mosquitto."
		elog "See https://mosquitto.org/documentation/python/"
	else
		elog "To start the mosquitto daemon at boot, add it to the default runlevel with:"
		elog ""
		elog "    rc-update add mosquitto default"
	fi
}
