DESCRIPTION = "Installer scripts for nand image"
LICENSE = "BSD"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "file://interfaces.in \
           file://nand-install.sh \
           file://network-setup.sh \
	   file://network-setup.sh \
	   file://bootpartition_tar_gz \
"

do_configure() {
    :
}

do_compile() {
    :
}

do_install () {
	
	install -m 0755 -d ${D}${ROOT_HOME}/Setup
        install -m 0755 ${WORKDIR}/nand-install.sh      ${D}${ROOT_HOME}/Setup/nand-install.sh
	install -m 0755 ${WORKDIR}/network-setup.sh     ${D}${ROOT_HOME}/Setup/network-setup.sh
	install -m 0644 ${WORKDIR}/interfaces.in        ${D}${ROOT_HOME}/Setup/interfaces.in		
	install -m 0644 ${WORKDIR}/bootpartition_tar_gz ${D}${ROOT_HOME}/Setup/bootpartition.tar.gz
}


FILES_${PN} = "${ROOT_HOME}/Setup/*"

