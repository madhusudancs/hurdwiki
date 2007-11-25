# "HurdToolchainMakefile" - a Makefile for setting up Hurd toolchain builds
#
# Copyright (c) 2007  Shakthi Kannan <shakthi.kannan@qvantel.com>
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# version 2 as published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA  02110-1301, USA

## Variables
TOPDIR=.
DOWNLOADS=${TOPDIR}/downloads
ROOT=${TOPDIR}/root
SRC=${ROOT}/src
GLIBC_DIR=${SRC}/glibc
PATCH0_DIR=patch0
PATCH1_DIR=patch1

## Patches
PATCH1 = 0003-2007-09-13-H.J.-Lu-hongjiu.lu-intel.com.patch \
	0005-Hurd-specific-kernel-features.h.patch \
	0007-2007-10-05-version-of-stat.patch.patch \
	0008-r2425-of-debian-patches-hurd-i386-local-atomic-no-mu.patch \
	0010-r2425-of-debian-patches-hurd-i386-local-gscope.diff.patch \
	0012-r2425-of-debian-patches-hurd-i386-local-no-strerror_.patch \
	0013-r2626-of-debian-patches-hurd-i386-local-tls-support.patch \
	0014-r2591-of-debian-patches-hurd-i386-local-tls.diff.patch \
	0015-r2630-of-debian-patches-hurd-i386-submitted-libc_onc.patch \
	0016-Include-stdint.h.patch \
	0017-r2598-of-debian-patches-any-local-stdio-lock.diff.patch \
	0018-r2650-of-debian-patches-hurd-i386-submitted-strtoul.patch \
	0019-2007-11-12-Aurelien-Jarno-aurelien-aurel32.net-Tho.patch \
	0020-r2656-of-debian-patches-any-submitted-sched_h.diff.patch \
	0022-2007-11-18-Roland-McGrath-roland-frob.com.patch

PATCH0 = 0009-2007-07-22-version-of-init-first.c_vs._GCC_4.1.patch.patch \
	0011-2007-02-08-version-of-resolv_res_send.c.patch.patch

all: create_dir get_sources apply_glibc_patches build_all

## Create directories
create_dir:
	cd ${TOPDIR}
	mkdir ${DOWNLOADS}
	mkdir -p ${SRC}

get_sources: get_cross_gnu get_binutils get_gcc get_gnumach get_mig get_hurd get_glibc

get_cross_gnu:
	@ echo "  ___ _ __ ___  ___ ___        __ _ _ __  _   _ "
	@ echo " / __| '__/ _ \/ __/ __|_____ / _\` | '_ \| | | |"
	@ echo "| (__| | | (_) \__ \__ \_____| (_| | | | | |_| |"
	@ echo " \___|_|  \___/|___/___/      \__, |_| |_|\__,_|"
	@ echo "                              |___/             "
	cd ${DOWNLOADS}; \
	wget http://nic-nac-project.de/~schwinge/tmp/cross-gnu
	@ echo "  ___ _ __ ___  ___ ___        __ _ _ __  _   _        ___ _ ____   __" 
	@ echo " / __| '__/ _ \/ __/ __|_____ / _\` | '_ \| | | |_____ / _ \ '_ \ \ / /"
	@ echo "| (__| | | (_) \__ \__ \_____| (_| | | | | |_| |_____|  __/ | | \ V / " 
	@ echo " \___|_|  \___/|___/___/      \__, |_| |_|\__,_|      \___|_| |_|\_/  " 
	@ echo "                              |___/                                   " 
	cd ${DOWNLOADS}; \
	wget http://nic-nac-project.de/~schwinge/tmp/cross-gnu-env; \
	chmod +x cross-gnu; \
	chmod +x cross-gnu-env

get_binutils:
	@ echo " _     _             _   _ _     "
	@ echo "| |__ (_)_ __  _   _| |_(_) |___ "
	@ echo "| '_ \| | '_ \| | | | __| | / __|"
	@ echo "| |_) | | | | | |_| | |_| | \__ \\"
	@ echo "|_.__/|_|_| |_|\__,_|\__|_|_|___/"
	cd ${SRC}; \
	cvs -d:pserver:anoncvs@sources.redhat.com:/cvs/src co -r binutils-2_18-branch binutils; \
	mv src binutils

get_gcc:
	@ echo "  __ _  ___ ___ "
	@ echo " / _\` |/ __/ __|"
	@ echo "| (_| | (_| (__ "
	@ echo " \__, |\___\___|"
	@ echo " |___/          "
	cd ${SRC}; \
	svn co svn://gcc.gnu.org/svn/gcc/branches/gcc-4_1-branch; \
	mv gcc-4_1-branch gcc; \
	( cd gcc/ && contrib/gcc_update --touch )

get_gnumach:
	@ echo "                                        _     "
	@ echo "  __ _ _ __  _   _ _ __ ___   __ _  ___| |__  "
	@ echo " / _\` | '_ \| | | | '_ \` _ \ / _\` |/ __| '_ \ "
	@ echo "| (_| | | | | |_| | | | | | | (_| | (__| | | |"
	@ echo " \__, |_| |_|\__,_|_| |_| |_|\__,_|\___|_| |_|"
	@ echo " |___/                                        "
	cd ${SRC}; \
	cvs -d:pserver:anoncvs@cvs.gnu.org:/cvsroot/hurd co -r gnumach-1-branch gnumach; \
	( cd gnumach/ && autoreconf -vfi )

get_mig:
	@ echo "           _       "
	@ echo " _ __ ___ (_) __ _ "
	@ echo "| '_ \` _ \| |/ _\` |"
	@ echo "| | | | | | | (_| |"
	@ echo "|_| |_| |_|_|\__, |"
	@ echo "             |___/ "
	cd ${SRC}; \
	cvs -d:pserver:anoncvs@cvs.gnu.org:/cvsroot/hurd co mig; \
	( cd mig/ && autoreconf -vfi )

get_hurd:
	@ echo " _                   _ "
	@ echo "| |__  _   _ _ __ __| |"
	@ echo "| '_ \| | | | '__/ _\` |"
	@ echo "| | | | |_| | | | (_| |"
	@ echo "|_| |_|\__,_|_|  \__,_|"
	cd ${SRC}; \
	cvs -d:pserver:anoncvs@cvs.gnu.org:/cvsroot/hurd co hurd

get_glibc:
	@ echo "       _ _ _          "
	@ echo "  __ _| (_) |__   ___ "
	@ echo " / _\` | | | '_ \ / __|"
	@ echo "| (_| | | | |_) | (__ "
	@ echo " \__, |_|_|_.__/ \___|"
	@ echo " |___/                "
	cd ${SRC}; \
	cvs -d:pserver:anoncvs@sources.redhat.com:/cvs/glibc co -r glibc-2_7-branch glibc; \
	mv libc glibc
	mkdir ${GLIBC_DIR}/${PATCH0_DIR}
	mkdir ${GLIBC_DIR}/${PATCH1_DIR}

get_patch0: $(PATCH0)

get_patch1: $(PATCH1)

$(PATCH1):
	wget -r -np -nd -P ${GLIBC_DIR}/${PATCH1_DIR} http://www.schwinge.homeip.net/~thomas/tmp/glibc-patches/$@ 
	cd ${GLIBC_DIR}; \
	patch -p1 < ${PATCH1_DIR}/$@

$(PATCH0): 
	wget -r -np -nd -P ${GLIBC_DIR}/${PATCH0_DIR} http://www.schwinge.homeip.net/~thomas/tmp/glibc-patches/$@
	cd ${GLIBC_DIR}; \
	patch -p0 < ${PATCH0_DIR}/$@

apply_glibc_patches: get_patch0 get_patch1

build_all:
	ROOT=${TOPDIR}/root ; \
	export PATH="$(PATH):$(DOWNLOADS)" ; \
	echo $$PATH ; \
	. ${DOWNLOADS}/cross-gnu-env ; \
	${DOWNLOADS}/cross-gnu

clean:
	rm -rf downloads root *~
