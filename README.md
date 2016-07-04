## Introduction

This project contains code to build .deb and .rpm packages for the [Suricata](http://suricata-ids.org/) IDS.
The packages will allow you to install Suricata in a manner that is compatible with the [Observable Networks](https://observable.net) monitoring service.

The .deb should work with Ubuntu 12.04 and 14.04. The .rpm should work with RHEL 6 and compatible (e.g. CentOS 6) distributions.

## Build instructions

The packages to install are listed below. On RHEL / CentOS you will need to first install the [EPEL repository](https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F) to get some of these packages. For more information on building Suricata, see the [Suricata wiki](https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Suricata_Installation).

Ubuntu systems | RHEL / CentOS systems
-------------|-------------
autoconf | autoconf
automake | automake
build-essential | gcc, gcc-c++
libcap-ng0, libcap-ng-dev | libcap-ng,libcap-ng-devel
libpcap-dev | libpcap, libpcap-devel
libjansson4, libjansson-dev | jansson, jansson-devel
libmagic-dev | file-devel
libnet1-dev  | libnet, libnet-devel
libpcre3, libpcre3-dev | pcre, pcre-devel
libtool | libtool
libyaml-0-2, libyaml-dev | libyaml, libyaml-devel
make | make
zlib1g, zlib1g-dev | zlib, zlib-devel

You will also need to [install `libhtp`](https://redmine.openinfosecfoundation.org/projects/suricata/wiki/HTP_library_installation).

To build the .deb and .rpm files you will need a working Ruby installation capable of installing the [`fpm`](https://github.com/jordansissel/fpm/wiki) gem.

Issue `make build_suricata` and then `make deb` or `make rpm` to create the packages.

## Credits and licenses

Suricata is licensed under the GNU General Public License (version 2). See the [Suricata license](https://github.com/inliniac/suricata/blob/master/LICENSE) for more information.

The packaging work done in this project is licensed under the Apache License (version 2.0). See the [Apache license](http://www.apache.org/licenses/LICENSE-2.0) for more information.
