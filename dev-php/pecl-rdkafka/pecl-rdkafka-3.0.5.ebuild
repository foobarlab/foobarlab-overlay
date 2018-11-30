# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="rdkafka"
USE_PHP="php5-6 php7-0 php7-1 php7-2"
MY_P="${PN/pecl-/}-${PV/_rc/RC}"
PHP_EXT_PECL_FILENAME="${MY_P}.tgz"
PHP_EXT_S="${WORKDIR}/${MY_P}"

inherit php-ext-pecl-r3

DESCRIPTION="PHP extension for interfacing with Apache Kafka"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DOCS=( CREDITS )

RDEPEND="
	php_targets_php5-6? ( dev-lang/php:5.6 )
	php_targets_php7-0? ( dev-lang/php:7.0 )
	php_targets_php7-1? ( dev-lang/php:7.1 )
	php_targets_php7-1? ( dev-lang/php:7.2 )
	>=dev-libs/librdkafka-0.9.0
"
DEPEND="${RDEPEND}"

# The test suite requires network access.
RESTRICT=test

S="${WORKDIR}/${MY_P}"

src_configure() {
	php-ext-source-r3_src_configure
}
