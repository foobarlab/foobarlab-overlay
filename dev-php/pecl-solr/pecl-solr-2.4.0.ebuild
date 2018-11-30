# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="solr"
USE_PHP="php5-6 php7-0 php7-1"
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension for interfacing with Apache Solr"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DOCS=( CREDITS docs/documentation.php )

RDEPEND="
	php_targets_php5-6? ( dev-lang/php:5.6[json,xml] )
	php_targets_php7-0? ( dev-lang/php:7.0[json,xml] )
	php_targets_php7-1? ( dev-lang/php:7.1[json,xml] )
	net-misc/curl
	>=dev-libs/libxml2-2.6.26
"
DEPEND="${RDEPEND}"

# The test suite requires network access.
RESTRICT=test

S="${WORKDIR}/${MY_P}"

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-solr
	)
	php-ext-source-r3_src_configure
}

# TODO test missing
