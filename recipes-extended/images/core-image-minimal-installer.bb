require recipes-core/images/core-image-minimal.bb

DESCRIPTION = "Small image capable of booting a device with support for the \
Minimal MTD Utilities, which let the user interact with the MTD subsystem in \
the kernel to perform operations on flash devices."

IMAGE_INSTALL += "mtd-utils \
		dosfstools \
		e2fsprogs-e2fsck \
		e2fsprogs-mke2fs \
		e2fsprogs-tune2fs \
		rsync \
		util-linux-mkfs \
                sunxi-tools \
	        mtd-utils-ubifs \
                mtd-utils-misc \
		"

IMAGE_FEATURES += "ssh-server-openssh package-management"

