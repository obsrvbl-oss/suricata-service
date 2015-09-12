VERSION := 0.01
TARGET_ROOT = $(shell pwd)/root

all:
	@echo please specify a target

build_suricata:
	mkdir -p ${TARGET_ROOT}/usr
	mkdir -p ${TARGET_ROOT}/etc
	mkdir -p ${TARGET_ROOT}/var
	cp -ar libhtp/ suricata/
	(cd suricata; ./autogen.sh)
	(cd suricata; \
		./configure \
			--prefix=/usr \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--disable-gccmarch-native \
			--enable-af-packet \
			--enable-gccprotect \
			--disable-coccinelle)
	make -C suricata
	make -C suricata install-full DESTDIR=${TARGET_ROOT}

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

rpm:
	mkdir -p packaging/output
	fpm \
		-s dir \
		-t rpm \
		-n suricata-service \
		-v ${VERSION} \
		-p packaging/output/suricata-service.rpm \
		-a all \
		--category admin \
		--force \
		--rpm-compression bzip2 \
		--description "Suricata service script" \
		--license "GPL v2" \
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
