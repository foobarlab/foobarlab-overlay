# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# dependencies, see: http://git.php.net/?p=pecl/search_engine/solr.git;a=blob;f=README.INSTALLATION;h=bc80b40f458ae3be626e2d888c08742c63f8d3e1;hb=HEAD
# FIXME: requires 'libxml' and 'json' PHP extensions
# FIXME: requires 'libxml2' library

EAPI=6

PHP_EXT_NAME="solr"
USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3"
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension for interfacing with Apache Solr"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND=""
RDEPEND="net-misc/curl"

# The test suite requires network access.
RESTRICT=test

S="${WORKDIR}/${MY_P}"

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-solr
	)
	php-ext-source-r3_src_configure
}
