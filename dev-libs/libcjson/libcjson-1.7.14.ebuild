# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Ultralightweight JSON parser in ANSI C"
HOMEPAGE="https://github.com/DaveGamble/cJSON"
SRC_URI="https://github.com/DaveGamble/cJSON/archive/v${PV}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64"
IUSE=""

S="${WORKDIR}/cJSON-${PV}"
