VERSION := 0.01

all:
	@echo please specify a target

deb:
	mkdir -p packaging/output
	fpm -s dir -t deb -n suricata-service -v ${VERSION} -p packaging/output/suricata-service.deb -a all \
		--category admin --force --deb-compression bzip2 --description "Suricata service script" --license "GPL v2" \
		root/=/

clean:
	rm -rf packaging/output/
