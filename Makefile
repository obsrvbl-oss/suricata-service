VERSION := 0.01
TARGET_ROOT = $(shell pwd)/root

all:
	@echo please specify a target

build_libhtp:
	(cd libhtp; ./autogen.sh)
	(cd libhtp; ./configure --prefix=${TARGET_ROOT})
	make -C libhtp
	make -C libhtp install

build_suricata: build_libhtp
build_suricata: export PKG_CONFIG_PATH = ${TARGET_ROOT}/lib/pkgconfig
build_suricata:
	mkdir -p root/usr
	mkdir -p root/etc
	mkdir -p root/var
	(cd suricata; ./autogen.sh)
	(cd suricata; \
		./configure \
			--prefix=${TARGET_ROOT}/usr \
			--sysconfdir=${TARGET_ROOT}/etc \
			--localstatedir=${TARGET_ROOT}/var \
			--enable-non-bundled-htp \
			--with-libhtp-includes=${TARGET_ROOT}/include \
			--with-libhtp-libraries=${TARGET_ROOT}/lib)
	make -C suricata
	make -C suricata install-full

deb:
	mkdir -p packaging/output
	fpm \
		-s dir \
		-t deb \
		-n suricata-service \
		-v ${VERSION} \
		-p packaging/output/suricata-service.deb \
		-a all \
		--category admin \
		--force \
		--deb-compression bzip2 \
		--description "Suricata service script" \
		--license "GPL v2" \
		--depends libnet1 \
		--depends libjansson4 \
		--depends libcap2-bin \
		--depends libyaml-0-2 \
		--depends sysvinit-utils \
		--deb-recommends ona-service \
		--after-install packaging/scripts/postinst.sh \
		--deb-no-default-config-files \
		root/=/

clean:
	(cd libhtp; git clean -fd)
	(cd suricata; git clean -fd)
	git clean -fd
