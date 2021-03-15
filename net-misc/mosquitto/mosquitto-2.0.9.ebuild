# Distributed under the terms of the GNU General Public License v2

EAPI=7

# FIXME switch to cmake

inherit toolchain-funcs user

DESCRIPTION="An Open Source MQTT v5.0/v3.1.1/v3.1 Broker"
HOMEPAGE="https://mosquitto.org/ https://github.com/eclipse/mosquitto"
SRC_URI="https://mosquitto.org/files/source/${P}.tar.gz"

LICENSE="EPL-2.0"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~x86"
IUSE="bridge +cjson examples libressl +persistence +srv ssl tcpd test websockets"
RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( bridge )"

RDEPEND="
	cjson? ( dev-libs/libcjson:= )
	srv? ( net-dns/c-ares:= )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	tcpd? ( sys-apps/tcp-wrappers )"

DEPEND="${RDEPEND}
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
		sed -i -e "/^#autosave_interval/s|^#||" \
			-e "s|^#persistence false$|persistence true|" \
			-e "/^#persistence_file/s|^#||" \
			-e "s|#persistence_location|persistence_location /var/lib/mosquitto/|" \
			mosquitto.conf || die
	fi

	# Remove prestripping
	sed -i -e 's/-s --strip-program=${CROSS_COMPILE}${STRIP}//'\
		client/Makefile lib/cpp/Makefile src/Makefile lib/Makefile || die
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
	elog "To start the mosquitto daemon at boot, add it to the default runlevel with:"
	elog ""
	elog "    rc-update add mosquitto default"
}
