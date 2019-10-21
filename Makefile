VERSION := 5.0.0
TARGET_ROOT = $(shell pwd)/root
LIBHTP_PREFIX = ${TARGET_ROOT}/usr/local
ARCH ?= amd64

all:
	@echo please specify a target

build_libhtp:
	mkdir -p ${LIBHTP_PREFIX}/lib
	(cd libhtp; ./autogen.sh)
	(cd libhtp; ./configure --prefix=${LIBHTP_PREFIX})
	make -C libhtp
	make -C libhtp install

build_suricata: build_libhtp
build_suricata: export PKG_CONFIG_PATH = ${LIBHTP_PREFIX}/lib/pkgconfig
build_suricata:
	mkdir -p ${TARGET_ROOT}/usr/share/doc/suricata/
	mkdir -p ${TARGET_ROOT}/etc
	mkdir -p ${TARGET_ROOT}/var
	(cd suricata; ./autogen.sh)
	(cd suricata; \
		./configure \
			--prefix=/usr \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--enable-non-bundled-htp \
			--enable-af-packet \
			--disable-coccinelle \
			--disable-suricata-update \
			--disable-gccmarch-native)
	LD_RUN_PATH="/usr/local/lib" make -C suricata
	make -C suricata install DESTDIR=${TARGET_ROOT}
	make -C suricata install-conf DESTDIR=${TARGET_ROOT}
	cp suricata/LICENSE ${TARGET_ROOT}/usr/share/doc/suricata/

deb:
	mkdir -p packaging/output
	fpm \
		-s dir \
		-t deb \
		-n suricata-service \
		-v ${VERSION} \
		-p packaging/output/suricata-service.deb \
		-a ${ARCH} \
		--category admin \
		--force \
		--description "Observable Networks Suricata Distribution" \
		--license "GNU General Public License v2.0" \
		--url "https://github.com/obsrvbl/suricata-service" \
		--depends libnet1 \
		--depends libjansson4 \
		--depends libcap2-bin \
		--depends libyaml-0-2 \
		--depends sysvinit-utils \
		--depends python2.7 \
		--deb-recommends ona-service \
		--after-install packaging/scripts/postinst.sh \
		--deb-no-default-config-files \
		root/=/

rpm6:
	mkdir -p packaging/output
	fpm \
		-s dir \
		-t rpm \
		-n suricata-service \
		-v ${VERSION} \
		-p packaging/output/suricata-service-6.rpm \
		-a ${ARCH} \
		--category admin \
		--force \
		--rpm-compression bzip2 \
		--description "Observable Networks Suricata Distribution" \
		--license "GNU General Public License v2.0" \
		--url "https://github.com/obsrvbl/suricata-service" \
		--depends jansson \
		--depends libcap-ng \
		--depends libpcap \
		--depends libnet \
		--depends libyaml \
		--depends pcre \
		--depends zlib \
		--depends python27 \
		--after-install packaging/scripts/postinst.sh \
		root/=/

rpm7:
	mkdir -p packaging/output
	fpm \
		-s dir \
		-t rpm \
		-n suricata-service \
		-v ${VERSION} \
		-p packaging/output/suricata-service-7.rpm \
		-a ${ARCH} \
		--category admin \
		--force \
		--rpm-compression bzip2 \
		--description "Observable Networks Suricata Distribution" \
		--license "GNU General Public License v2.0" \
		--url "https://github.com/obsrvbl/suricata-service" \
		--depends jansson \
		--depends libcap-ng \
		--depends libpcap \
		--depends libnet \
		--depends libyaml \
		--depends pcre \
		--depends zlib \
		--after-install packaging/scripts/postinst.sh \
		root/=/

clean:
	rm -rf packaging/output
	rm -rf suricata/
	rm -rf libhtp/
	git submodule update
	git clean -fd
