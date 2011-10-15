#!/bin/sh -x

workdir=`pwd`
tempdir=/tmp/INSTALL.$$

version=0.8.8
siteurl=http://releases.compiz.org/${version}

pkglist="
compiz
libcompizconfig
compiz-fusion-bcop
compiz-fusion-plugins-main
compiz-fusion-plugins-extra
compiz-fusion-plugins-unsupported
compizconfig-backend-gconf
compizconfig-backend-kconfig
emerald
"

for debian_package in `echo ${pkglist}`
do
	compiz_package=`echo ${debian_package} | sed 's/-fusion//g;s/-kconfig/-kconfig4/g'`

	compiz_dirname=${compiz_package}-${version}
	compiz_archive=${compiz_package}-${version}.tar.gz

	debian_dirname=${debian_package}-${version}
	debian_archive=${debian_package}_${version}.orig.tar.gz

	cd ${workdir}

	if [ ! -e releases/${compiz_archive} ]
	then
		mkdir -p releases
		cd releases
		wget ${siteurl}/${compiz_archive} || exit 1
	fi

	mkdir -p ${tempdir}
	cd ${tempdir}

	tar zxf ${workdir}/releases/${compiz_archive}
	if [ ${compiz_dirname} != ${debian_dirname} ]
	then
		mv ${compiz_dirname} ${debian_dirname}
	fi
	tar zcf ${debian_archive} ${debian_dirname}
	
	mkdir -p ${workdir}/${debian_dirname}
	cd ${workdir}/${debian_dirname}

	mv ${tempdir}/${debian_archive} .
	tar zxf ${debian_archive}

	cd ${debian_dirname}
	debuild -us -uc || exit 1
	sudo dpkg -i ../*.deb || exit 1

done

rm -fr ${tempdir}

