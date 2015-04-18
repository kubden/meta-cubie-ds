DESCRIPTION = "Installer scripts for nand image"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

PR = "r1"
SRCREV = "${AUTOREV}"
S = "${WORKDIR}/git"

#PKGV = "0.1+gitr${GITPKGV}"
#PV = "${PKGV}"

#INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INSANE_SKIP_${PN} += "ldflags"
INSANE_SKIP_${PN} += "already-stripped"



SRC_URI = "file://interfaces.in \
           file://nand-install.sh \
           file://network-setup.sh \
           git://github.com/remahl/sunxi-bin-archive.git;protocol=git;branch=master \	
"

do_configure() {
    :
}

do_compile() {
    :
}

do_install () {	
	install -m 0755 -d ${D}${ROOT_HOME}/Setup
	install -m 0755 -d ${D}${ROOT_HOME}/Data
	install -m 0755 -d ${D}${ROOT_HOME}/Bootpart

	

    	install -m 0755 ${WORKDIR}/nand-install.sh      ${D}${ROOT_HOME}/Setup/nand-install.sh
	install -m 0755 ${WORKDIR}/network-setup.sh     ${D}${ROOT_HOME}/Setup/network-setup.sh
	install -m 0644 ${WORKDIR}/interfaces.in        ${D}${ROOT_HOME}/Setup/interfaces.in
	touch ${D}${ROOT_HOME}/Data/Download_Files_Here	

	cp -rpP ${S}/cubietruck-nand-boot/* ${D}/${ROOT_HOME}/Bootpart
}

FILES_${PN} = "${ROOT_HOME}/Setup/* \
	${ROOT_HOME}/Data/* \
	${ROOT_HOME}/Bootpart/* \
"

