#!/usr/bin/sudo /bin/bash

MIN_RELEASE_MAJOR="16"
MIN_RELEASE_MINOR="04"
REC_RELEASE_MAJOR="16"
REC_RELEASE_MINOR="04"

MIN_FREE_SPACE_ROOT_GB=5
REC_FREE_SPACE_ROOT_GB=10
MIN_FREE_SPACE_DOCK_GB=5
REC_FREE_SPACE_DOCK_GB=10

MEM_AMOUNT_ERROR_GB=8
MEM_AMOUNT_WARNING_GB=16

SPDTST_PING_TIME_ERROR_MS=500
SPDTST_PING_TIME_WARNING_MS=100
SPDTST_MIN_UPLOAD_SPD_MBITPS=10
SPDTST_WARN_UPLOAD_SPD_MBITPS=20
SPDTST_MIN_DLOAD_SPD_MBITPS=10
SPDTST_WARN_DLOAD_SPD_MBITPS=20

DISK_CACHED_READS_MIN_SPD_MBPS=2000
DISK_CACHED_READS_WARN_SPD_MBPS=2500
DISK_BUFFERED_READS_MIN_SPD_MBPS=30 #Real value should be 50
DISK_BUFFERED_READS_WARN_SPD_MBPS=100

CURL_TEST_DNS_TIME_ERROR=2
CURL_TEST_DNS_TIME_WARNING=1
CURL_TEST_TOTAL_TIME_ERROR=5
CURL_TEST_TOTAL_TIME_WARNING=2

URLS_TO_CHECK='http://www.google.com/ https://www.google.com/ http://www.ericom.com/ https://www.ericom.com/ https://hub.docker.com/'
SHIELD_NETWORK_ADDR_BLOCK='10.20.0.0/16'

################################################################################

LOGFILE="${LOGFILE:-./shield_pre_install_check.log}"

function define_heredoc_var() { IFS='\n' read -r -d '' ${1} || true; }

define_heredoc_var SHIELD_PRE_INSTALL_CHECK_VIRT_SH <<'EOF'
#!/bin/bash -
# virt-what.  Generated from virt-what.in by configure.
# Copyright (C) 2008-2011 Red Hat Inc.
# Do not allow unset variables, and set defaults.
set -u
root=''
skip_qemu_kvm=false
 
VERSION="1.13"
 
function fail {
    echo "virt-what: $1" >&2
    exit 1
}
 
function usage {
    echo "virt-what [options]"
    echo "Options:"
    echo "  --help          Display this help"
    echo "  --version       Display version and exit"
    exit 0
}
 
# Handle the command line arguments, if any.
 
TEMP=$(getopt -o v --long help --long version --long test-root: -n 'virt-what' -- "$@")
if [ $? != 0 ]; then exit 1; fi
eval set -- "$TEMP"
 
while true; do
    case "$1" in
	--help) usage ;;
        --test-root)
            # Deliberately undocumented: used for 'make check'.
            root="$2"
            shift 2
            ;;
	-v|--version) echo "$VERSION"; exit 0 ;;
	--) shift; break ;;
	*) fail "internal error ($1)" ;;
    esac
done
 
# Add /sbin and /usr/sbin to the path so we can find system
# binaries like dmicode.
# Add /usr/libexec to the path so we can find the helper binary.
prefix=/usr
exec_prefix=${prefix}
PATH="${root}${prefix}/lib/virt-what:${root}/sbin:${root}/usr/sbin:${PATH}"
 
# Check we're running as root.
 
if [ "x$root" = "x" ] && [ "$EUID" -ne 0 ]; then
    fail "this script must be run as root"
fi
 
# Many fullvirt hypervisors give an indication through CPUID.  Use the
# helper program to get this information.
 
cpuid=$(virt-what-cpuid-helper)
 
# Check for various products in the BIOS information.
# Note that dmidecode doesn't exist on non-PC architectures.  On these,
# this will return an error which is ignored (error message redirected
# into $dmi variable).
 
dmi=$(LANG=C dmidecode 2>&1)
 
# Architecture.
# Note for the purpose of testing, we only call uname with -p option.
 
arch=$(uname -p)
 
# Check for VMware.
# cpuid check added by Chetan Loke.
 
if [ "$cpuid" = "VMwareVMware" ]; then
    echo vmware
elif echo "$dmi" | grep -q 'Manufacturer: VMware'; then
    echo vmware
fi
 
# Check for Hyper-V.
# http://blogs.msdn.com/b/sqlosteam/archive/2010/10/30/is-this-real-the-metaphysics-of-hardware-virtualization.aspx
if [ "$cpuid" = "Microsoft Hv" ]; then
    echo hyperv
fi
 
# Check for VirtualPC.
# The negative check for cpuid is to distinguish this from Hyper-V
# which also has the same manufacturer string in the SM-BIOS data.
if [ "$cpuid" != "Microsoft Hv" ] &&
    echo "$dmi" | grep -q 'Manufacturer: Microsoft Corporation'; then
    echo virtualpc
fi
 
# Check for VirtualBox.
# Added by Laurent LÃ©onard.
if echo "$dmi" | grep -q 'Manufacturer: innotek GmbH'; then
    echo virtualbox
fi
 
# Check for OpenVZ / Virtuozzo.
# Added by Evgeniy Sokolov.
# /proc/vz - always exists if OpenVZ kernel is running (inside and outside
# container)
# /proc/bc - exists on node, but not inside container.
 
if [ -d "${root}/proc/vz" -a ! -d "${root}/proc/bc" ]; then
    echo openvz
fi
 
# Check for LXC containers
# http://www.freedesktop.org/wiki/Software/systemd/ContainerInterface
# Added by Marc Fournier
 
if [ -e "${root}/proc/1/environ" ] &&
    cat "${root}/proc/1/environ" | tr '\000' '\n' | grep -Eiq '^container='; then
    echo lxc
fi
 
# Check for Linux-VServer
if cat "${root}/proc/self/status" | grep -q "VxID: [0-9]*"; then
    echo linux_vserver
fi
 
# Check for UML.
# Added by Laurent LÃ©onard.
if grep -q 'UML' "${root}/proc/cpuinfo"; then
    echo uml
fi
 
# Check for IBM PowerVM Lx86 Linux/x86 emulator.
if grep -q '^vendor_id.*PowerVM Lx86' "${root}/proc/cpuinfo"; then
    echo powervm_lx86
fi
 
# Check for Hitachi Virtualization Manager (HVM) Virtage logical partitioning.
if echo "$dmi" | grep -q 'Manufacturer.*HITACHI' &&
   echo "$dmi" | grep -q 'Product.* LPAR'; then
    echo virtage
fi
 
# Check for IBM SystemZ.
if grep -q '^vendor_id.*IBM/S390' "${root}/proc/cpuinfo"; then
    echo ibm_systemz
    if [ -f "${root}/proc/sysinfo" ]; then
        if grep -q 'VM.*Control Program.*z/VM' "${root}/proc/sysinfo"; then
            echo ibm_systemz-zvm
        elif grep -q '^LPAR' "${root}/proc/sysinfo"; then
            echo ibm_systemz-lpar
        else
            # This is unlikely to be correct.
            echo ibm_systemz-direct
        fi
    fi
fi
 
# Check for Parallels.
if echo "$dmi" | grep -q 'Vendor: Parallels'; then
    echo parallels
    skip_qemu_kvm=true
fi
 
# Check for Xen.
 
if [ "$cpuid" = "XenVMMXenVMM" ]; then
    echo xen; echo xen-hvm
    skip_qemu_kvm=true
elif [ -f "${root}/proc/xen/capabilities" ]; then
    echo xen
    if grep -q "control_d" "${root}/proc/xen/capabilities"; then
        echo xen-dom0
    else
        echo xen-domU
    fi
    skip_qemu_kvm=true
elif [ -f "${root}/sys/hypervisor/type" ] &&
    grep -q "xen" "${root}/sys/hypervisor/type"; then
    # Ordinary kernel with pv_ops.  There does not seem to be
    # enough information at present to tell whether this is dom0
    # or domU.  XXX
    echo xen
elif [ "$arch" = "ia64" ]; then
    if [ -d "${root}/sys/bus/xen" -a ! -d "${root}/sys/bus/xen-backend" ]; then
        # PV-on-HVM drivers installed in a Xen guest.
        echo xen
        echo xen-hvm
    else
        # There is no virt leaf on IA64 HVM.  This is a last-ditch
        # attempt to detect something is virtualized by using a
        # timing attack.
        virt-what-ia64-xen-rdtsc-test > /dev/null 2>&1
        case "$?" in
            0) ;; # not virtual
            1) # Could be some sort of virt, or could just be a bit slow.
                echo virt
        esac
    fi
fi
 
# Check for QEMU/KVM.
#
# Parallels exports KVMKVMKVM leaf, so skip this test if we've already
# seen that it's Parallels.  Xen uses QEMU as the device model, so
# skip this test if we know it is Xen.
 
if ! "$skip_qemu_kvm"; then
    if [ "$cpuid" = "KVMKVMKVM" ]; then
	echo kvm
    else
        # XXX This is known to fail for qemu with the explicit -cpu
        # option, since /proc/cpuinfo will not contain the QEMU
        # string.  The long term fix for this would be to export
        # another CPUID leaf for non-accelerated qemu.
        if grep -q 'QEMU' "${root}/proc/cpuinfo"; then
	    echo qemu
	fi
    fi
fi
EOF
#'

define_heredoc_var IPCALC_PY <<'EOF'
# -*- coding: utf-8 -*-
# pep8-ignore: E501, E241
# pylint: disable=invalid-name
#

"""
IP subnet calculator.

.. moduleauthor:: Wijnand Modderman-Lenstra <maze@pyth0n.org>
.. note:: BSD License

About
=====

This module allows you to perform network calculations.

References
==========

References:
 * http://www.estoile.com/links/ipv6.pdf
 * http://www.iana.org/assignments/ipv4-address-space
 * http://www.iana.org/assignments/multicast-addresses
 * http://www.iana.org/assignments/ipv6-address-space
 * http://www.iana.org/assignments/ipv6-tla-assignments
 * http://www.iana.org/assignments/ipv6-multicast-addresses
 * http://www.iana.org/assignments/ipv6-anycast-addresses

Thanks
======

Thanks to all who have contributed:

https://github.com/tehmaze/ipcalc/graphs/contributors
"""

from __future__ import print_function

__version__ = '1.99.0'


import re
import six


MAX_IPV6 = (1 << 128) - 1
MAX_IPV4 = (1 << 32) - 1
BASE_6TO4 = (0x2002 << 112)


class IP(object):

    """
    Represent a single IP address.

    :param ip: the ip address
    :type ip: :class:`IP` or str or long or int

    >>> localhost = IP("127.0.0.1")
    >>> print(localhost)
    127.0.0.1
    >>> localhost6 = IP("::1")
    >>> print(localhost6)
    0000:0000:0000:0000:0000:0000:0000:0001
    """

    # Hex-to-Bin conversion masks
    _bitmask = {
        '0': '0000', '1': '0001', '2': '0010', '3': '0011',
        '4': '0100', '5': '0101', '6': '0110', '7': '0111',
        '8': '1000', '9': '1001', 'a': '1010', 'b': '1011',
        'c': '1100', 'd': '1101', 'e': '1110', 'f': '1111'
    }

    # IP range specific information, see IANA allocations.
    _range = {
        # http://www.iana.org/assignments/iana-ipv4-special-registry/iana-ipv4-special-registry.xhtml
        4: {
            '00000000':                 'THIS HOST',             # 0/8
            '00001010':                 'PRIVATE',               # 10/8
            '0110010001':               'SHARED ADDRESS SPACE',  # 100.64/10
            '01111111':                 'LOOPBACK',              # 127/8
            '101011000001':             'PRIVATE',               # 172.16/12
            '110000000000000000000000': 'IETF PROTOCOL',         # 192/24
            '110000000000000000000010': 'TEST-NET-1',            # 192.0.2/24
            '110000000101100001100011': '6TO4-RELAY ANYCAST',    # 192.88.99/24
            '1100000010101000':         'PRIVATE',               # 192.168/16
            '110001100001001':          'BENCHMARKING',          # 198.18/15
            '110001100011001':          'TEST-NET-2',            # 198.51.100/24
            '110010110000000':          'TEST-NET-3',            # 203.0.113/24
            '1111':                     'RESERVED',              # 240/4

        },
        # http://www.iana.org/assignments/iana-ipv6-special-registry/iana-ipv6-special-registry.xhtml
        6: {
            '0' * 128:                          'UNSPECIFIED',    # ::/128
            '0' * 127 + '1':                    'LOOPBACK',       # ::1/128
            '0' * 96:                           'IPV4COMP',       # ::/96
            '0' * 80 + '1' * 16:                'IPV4MAP',        # ::ffff:0:0/96
                                                                  # 64:ff9b::/96
            '00000000011001001111111110011011' + 64 * '0': 'IPV4-IPV6',
            '00000001' + 56 * '0':              'DISCARD-ONLY',   # 100::/64
            '0010000000000001' + 7 * '0':       'IETF PROTOCOL',  # 2001::/23
            '0010000000000001' + 16 * '0':      'TEREDO',         # 2001::/32
                                                                  # 2001:2::/48
            '00100000000000010000000000000010000000000000000': 'BENCHMARKING',
            '00100000000000010000110110111000': 'DOCUMENTATION',  # 2001:db8::/32
            '0010000000000001000000000001':     'DEPRECATED',     # 2001:10::/28
            '0010000000000001000000000010':     'ORCHIDv2',       # 2001:20::/28
            '0010000000000010':                 '6TO4',           # 2002::/16
            '11111100000000000':                'UNIQUE-LOCAL',   # fc00::/7
            '1111111010':                       'LINK-LOCAL',     # fe80::/10
        }
    }

    def __init__(self, ip, mask=None, version=0):
        """Initialize a new IPv4 or IPv6 address."""
        self.mask = mask
        self.v = 0
        # Parse input
        if ip is None:
            raise ValueError('Can not pass None')
        elif isinstance(ip, IP):
            self.ip = ip.ip
            self.dq = ip.dq
            self.v = ip.v
            self.mask = ip.mask
        elif isinstance(ip, six.integer_types):
            self.ip = int(ip)
            if self.ip <= MAX_IPV4:
                self.v = version or 4
                self.dq = self._itodq(ip)
            else:
                self.v = version or 6
                self.dq = self._itodq(ip)
        else:
            # network identifier
            if '%' in ip:
                ip = ip.split('%', 1)[0]
            # If string is in CIDR or netmask notation
            if '/' in ip:
                ip, mask = ip.split('/', 1)
                self.mask = mask
            self.v = version or 0
            self.dq = ip
            self.ip = self._dqtoi(ip)
            assert self.v != 0, 'Could not parse input'
        # Netmask defaults to one ip
        if self.mask is None:
            self.mask = {4: 32, 6: 128}[self.v]
        # Netmask is numeric CIDR subnet
        elif isinstance(self.mask, six.integer_types) or self.mask.isdigit():
            self.mask = int(self.mask)
        # Netmask is in subnet notation
        elif isinstance(self.mask, six.string_types):
            limit = [32, 128][':' in self.mask]
            inverted = ~self._dqtoi(self.mask)
            if inverted == -1:
                self.mask = 0
            else:
                count = 0
                while inverted & pow(2, count):
                    count += 1
                self.mask = (limit - count)
        else:
            raise ValueError('Invalid netmask')
        # Validate subnet size
        if self.v == 6:
            self.dq = self._itodq(self.ip)
            if not 0 <= self.mask <= 128:
                raise ValueError('IPv6 subnet size must be between 0 and 128')
        elif self.v == 4:
            if not 0 <= self.mask <= 32:
                raise ValueError('IPv4 subnet size must be between 0 and 32')

    def bin(self):
        """Full-length binary representation of the IP address.

        >>> ip = IP("127.0.0.1")
        >>> print(ip.bin())
        01111111000000000000000000000001
        """
        bits = self.v == 4 and 32 or 128
        return bin(self.ip).split('b')[1].rjust(bits, '0')

    def hex(self):
        """Full-length hexadecimal representation of the IP address.

        >>> ip = IP("127.0.0.1")
        >>> print(ip.hex())
        7f000001
        """
        if self.v == 4:
            return '%08x' % self.ip
        else:
            return '%032x' % self.ip

    def subnet(self):
        """CIDR subnet size."""
        return self.mask

    def version(self):
        """IP version.

        >>> ip = IP("127.0.0.1")
        >>> print(ip.version())
        4
        """
        return self.v

    def info(self):
        """Show IANA allocation information for the current IP address.

        >>> ip = IP("127.0.0.1")
        >>> print(ip.info())
        LOOPBACK
        """
        b = self.bin()
        for i in range(len(b), 0, -1):
            if b[:i] in self._range[self.v]:
                return self._range[self.v][b[:i]]
        return 'UNKNOWN'

    def _dqtoi(self, dq):
        """Convert dotquad or hextet to long."""
        # hex notation
        if dq.startswith('0x'):
            return self._dqtoi_hex(dq)

        # IPv6
        if ':' in dq:
            return self._dqtoi_ipv6(dq)
        elif len(dq) == 32:
            # Assume full heximal notation
            self.v = 6
            return int(dq, 16)

        # IPv4
        if '.' in dq:
            return self._dqtoi_ipv4(dq)

        raise ValueError('Invalid address input')

    def _dqtoi_hex(self, dq):
        ip = int(dq[2:], 16)
        if ip > MAX_IPV6:
            raise ValueError('%s: IP address is bigger than 2^128' % dq)
        if ip <= MAX_IPV4:
            self.v = 4
        else:
            self.v = 6
        return ip

    def _dqtoi_ipv4(self, dq):
        q = dq.split('.')
        q.reverse()
        if len(q) > 4:
            raise ValueError('%s: IPv4 address invalid: '
                             'more than 4 bytes' % dq)
        for x in q:
            if not 0 <= int(x) <= 255:
                raise ValueError('%s: IPv4 address invalid: '
                                 'bytes should be between 0 and 255' % dq)
        while len(q) < 4:
            q.insert(1, '0')
        self.v = 4
        return sum(int(byte) << 8 * index for index, byte in enumerate(q))

    def _dqtoi_ipv6(self, dq):
        # Split hextets
        hx = dq.split(':')
        if ':::' in dq:
            raise ValueError("%s: IPv6 address can't contain :::" % dq)
        # Mixed address (or 4-in-6), ::ffff:192.0.2.42
        if '.' in dq:
            col_ind = dq.rfind(":")
            ipv6part = dq[:col_ind] + ":0:0"
            return self._dqtoi_ipv6(ipv6part) + self._dqtoi(hx[-1])
        if len(hx) > 8:
            raise ValueError('%s: IPv6 address with more than 8 hexlets' % dq)
        elif len(hx) < 8:
            # No :: in address
            if '' not in hx:
                raise ValueError('%s: IPv6 address invalid: '
                                 'compressed format malformed' % dq)
            elif not (dq.startswith('::') or dq.endswith('::')) and len([x for x in hx if x == '']) > 1:
                raise ValueError('%s: IPv6 address invalid: '
                                 'compressed format malformed' % dq)
            ix = hx.index('')
            px = len(hx[ix + 1:])
            for x in range(ix + px + 1, 8):
                hx.insert(ix, '0')
        elif dq.endswith('::'):
            pass
        elif '' in hx:
            raise ValueError('%s: IPv6 address invalid: '
                             'compressed format detected in full notation' % dq())
        ip = ''
        hx = [x == '' and '0' or x for x in hx]
        for h in hx:
            if len(h) < 4:
                h = '%04x' % int(h, 16)
            if not 0 <= int(h, 16) <= 0xffff:
                raise ValueError('%r: IPv6 address invalid: '
                                 'hexlets should be between 0x0000 and 0xffff' % dq)
            ip += h
        self.v = 6
        return int(ip, 16)

    def _itodq(self, n):
        """Convert long to dotquad or hextet."""
        if self.v == 4:
            return '.'.join(map(str, [
                (n >> 24) & 0xff,
                (n >> 16) & 0xff,
                (n >> 8) & 0xff,
                n & 0xff,
            ]))
        else:
            n = '%032x' % n
            return ':'.join(n[4 * x:4 * x + 4] for x in range(0, 8))

    def __str__(self):
        """Return dotquad representation of the IP.

        >>> ip = IP("::1")
        >>> print(str(ip))
        0000:0000:0000:0000:0000:0000:0000:0001
        """
        return self.dq

    def __repr__(self):
        """Return canonical representation of the IP.

        >>> repr(IP("::1"))
        "IP('::1')"
        >>> repr(IP("fe80:0000:0000:0000:abde:3eff:ffab:0012/64"))
        "IP('fe80::abde:3eff:ffab:12/64')"
        >>> repr(IP("1.2.3.4/29"))
        "IP('1.2.3.4/29')"
        >>> repr(IP("127.0.0.1/8"))
        "IP('127.0.0.1/8')"
        """
        dq = self.dq if self.v == 4 else self.to_compressed()
        args = (self.__class__.__name__, dq, self.mask)
        if (self.version(), self.mask) in [(4, 32), (6, 128)]:
            fmt = "{0}('{1}')"
        else:
            fmt = "{0}('{1}/{2}')"
        return fmt.format(*args)

    def __hash__(self):
        """Hash for collection operations and py:`hash()`."""
        return hash(self.to_tuple())

    hash = __hash__

    def __int__(self):
        """Convert to int."""
        return int(self.ip)

    def __long__(self):
        """Convert to long."""
        return self.ip

    def __lt__(self, other):
        """Less than other test."""
        return int(self) < int(IP(other))

    def __le__(self, other):
        """Less than or equal to other test."""
        return int(self) <= int(IP(other))

    def __ge__(self, other):
        """Greater than or equal to other test."""
        return int(self) >= int(IP(other))

    def __gt__(self, other):
        """Greater than other."""
        return int(self) > int(IP(other))

    def __eq__(self, other):
        """Test if other is address is equal to the current address."""
        return int(self) == int(IP(other))

    def __add__(self, offset):
        """Add numeric offset to the IP."""
        if not isinstance(offset, six.integer_types):
            return ValueError('Value is not numeric')
        return self.__class__(self.ip + offset, mask=self.mask, version=self.v)

    def __sub__(self, offset):
        """Substract numeric offset from the IP."""
        if not isinstance(offset, six.integer_types):
            return ValueError('Value is not numeric')
        return self.__class__(self.ip - offset, mask=self.mask, version=self.v)

    @staticmethod
    def size():
        """Return network size."""
        return 1

    def clone(self):
        """
        Return a new <IP> object with a copy of this one.

        >>> ip = IP('127.0.0.1')
        >>> ip2 = ip.clone()
        >>> ip2
        IP('127.0.0.1')
        >>> ip is ip2
        False
        >>> ip == ip2
        True
        >>> ip.mask = 24
        >>> ip2.mask
        32
        """
        return IP(self)

    def to_compressed(self):
        """
        Compress an IP address to its shortest possible compressed form.

        >>> print(IP('127.0.0.1').to_compressed())
        127.1
        >>> print(IP('127.1.0.1').to_compressed())
        127.1.1
        >>> print(IP('127.0.1.1').to_compressed())
        127.0.1.1
        >>> print(IP('2001:1234:0000:0000:0000:0000:0000:5678').to_compressed())
        2001:1234::5678
        >>> print(IP('1234:0000:0000:beef:0000:0000:0000:5678').to_compressed())
        1234:0:0:beef::5678
        >>> print(IP('0000:0000:0000:0000:0000:0000:0000:0001').to_compressed())
        ::1
        >>> print(IP('fe80:0000:0000:0000:0000:0000:0000:0000').to_compressed())
        fe80::
        """
        if self.v == 4:
            quads = self.dq.split('.')
            try:
                zero = quads.index('0')
                if zero == 1 and quads.index('0', zero + 1):
                    quads.pop(zero)
                    quads.pop(zero)
                    return '.'.join(quads)
                elif zero == 2:
                    quads.pop(zero)
                    return '.'.join(quads)
            except ValueError:  # No zeroes
                pass

            return self.dq
        else:
            quads = map(lambda q: '%x' % (int(q, 16)), self.dq.split(':'))
            quadc = ':%s:' % (':'.join(quads),)
            zeros = [0, -1]

            # Find the largest group of zeros
            for match in re.finditer(r'(:[:0]+)', quadc):
                count = len(match.group(1)) - 1
                if count > zeros[0]:
                    zeros = [count, match.start(1)]

            count, where = zeros
            if count:
                quadc = quadc[:where] + ':' + quadc[where + count:]

            quadc = re.sub(r'((^:)|(:$))', '', quadc)
            quadc = re.sub(r'((^:)|(:$))', '::', quadc)

            return quadc

    def to_ipv4(self):
        """
        Convert (an IPv6) IP address to an IPv4 address, if possible.

        Only works for IPv4-compat (::/96), IPv4-mapped (::ffff/96), and 6-to-4
        (2002::/16) addresses.

        >>> ip = IP('2002:c000:022a::')
        >>> print(ip.to_ipv4())
        192.0.2.42
        """
        if self.v == 4:
            return self
        else:
            if self.bin().startswith('0' * 96):
                return IP(int(self), version=4)
            elif self.bin().startswith('0' * 80 + '1' * 16):
                return IP(int(self) & MAX_IPV4, version=4)
            elif int(self) & BASE_6TO4:
                return IP((int(self) - BASE_6TO4) >> 80, version=4)
            else:
                return ValueError('%s: IPv6 address is not IPv4 compatible or mapped, '
                                  'nor an 6-to-4 IP' % self.dq)

    @classmethod
    def from_bin(cls, value):
        """Initialize a new network from binary notation."""
        value = value.lstrip('b')
        if len(value) == 32:
            return cls(int(value, 2))
        elif len(value) == 128:
            return cls(int(value, 2))
        else:
            return ValueError('%r: invalid binary notation' % (value,))

    @classmethod
    def from_hex(cls, value):
        """Initialize a new network from hexadecimal notation."""
        if len(value) == 8:
            return cls(int(value, 16))
        elif len(value) == 32:
            return cls(int(value, 16))
        else:
            raise ValueError('%r: invalid hexadecimal notation' % (value,))

    def to_ipv6(self, ip_type='6-to-4'):
        """
        Convert (an IPv4) IP address to an IPv6 address.

        >>> ip = IP('192.0.2.42')
        >>> print(ip.to_ipv6())
        2002:c000:022a:0000:0000:0000:0000:0000

        >>> print(ip.to_ipv6('compat'))
        0000:0000:0000:0000:0000:0000:c000:022a

        >>> print(ip.to_ipv6('mapped'))
        0000:0000:0000:0000:0000:ffff:c000:022a
        """
        assert ip_type in ['6-to-4', 'compat', 'mapped'], 'Conversion ip_type not supported'
        if self.v == 4:
            if ip_type == '6-to-4':
                return IP(BASE_6TO4 | int(self) << 80, version=6)
            elif ip_type == 'compat':
                return IP(int(self), version=6)
            elif ip_type == 'mapped':
                return IP(0xffff << 32 | int(self), version=6)
        else:
            return self

    def to_reverse(self):
        """Convert the IP address to a PTR record.

        Using the .in-addr.arpa zone for IPv4 and .ip6.arpa for IPv6 addresses.

        >>> ip = IP('192.0.2.42')
        >>> print(ip.to_reverse())
        42.2.0.192.in-addr.arpa
        >>> print(ip.to_ipv6().to_reverse())
        0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.a.2.2.0.0.0.0.c.2.0.0.2.ip6.arpa
        """
        if self.v == 4:
            return '.'.join(list(self.dq.split('.')[::-1]) + ['in-addr', 'arpa'])
        else:
            return '.'.join(list(self.hex())[::-1] + ['ip6', 'arpa'])

    def to_tuple(self):
        """Used for comparisons."""
        return (self.dq, self.mask)

    def guess_network(self):
        netmask = 0x100000000 - 2**(32-self.mask)
        return Network(netmask & self.ip, mask=self.mask)


class Network(IP):

    """
    Network slice calculations.

    :param ip: network address
    :type ip: :class:`IP` or str or long or int
    :param mask: netmask
    :type mask: int or str


    >>> localnet = Network('127.0.0.1/8')
    >>> print(localnet)
    127.0.0.1/8
    """

    def netmask(self):
        """
        Network netmask derived from subnet size, as IP object.

        >>> localnet = Network('127.0.0.1/8')
        >>> print(localnet.netmask())
        255.0.0.0
        """
        return IP(self.netmask_long(), version=self.version())

    def netmask_long(self):
        """
        Network netmask derived from subnet size, as long.

        >>> localnet = Network('127.0.0.1/8')
        >>> print(localnet.netmask_long())
        4278190080
        """
        if self.version() == 4:
            return (MAX_IPV4 >> (32 - self.mask)) << (32 - self.mask)
        else:
            return (MAX_IPV6 >> (128 - self.mask)) << (128 - self.mask)

    def network(self):
        """
        Network address, as IP object.

        >>> localnet = Network('127.128.99.3/8')
        >>> print(localnet.network())
        127.0.0.0
        """
        return IP(self.network_long(), version=self.version())

    def network_long(self):
        """
        Network address, as long.

        >>> localnet = Network('127.128.99.3/8')
        >>> print(localnet.network_long())
        2130706432
        """
        return self.ip & self.netmask_long()

    def broadcast(self):
        """
        Broadcast address, as IP object.

        >>> localnet = Network('127.0.0.1/8')
        >>> print(localnet.broadcast())
        127.255.255.255
        """
        # XXX: IPv6 doesn't have a broadcast address, but it's used for other
        #      calculations such as <Network.host_last>
        return IP(self.broadcast_long(), version=self.version())

    def broadcast_long(self):
        """
        Broadcast address, as long.

        >>> localnet = Network('127.0.0.1/8')
        >>> print(localnet.broadcast_long())
        2147483647
        """
        if self.version() == 4:
            return self.network_long() | (MAX_IPV4 - self.netmask_long())
        else:
            return self.network_long() \
                | (MAX_IPV6 - self.netmask_long())

    def host_first(self):
        """First available host in this subnet."""
        if (self.version() == 4 and self.mask > 30) or \
                (self.version() == 6 and self.mask > 126):
            return self
        else:
            return IP(self.network_long() + 1, version=self.version())

    def host_last(self):
        """Last available host in this subnet."""
        if (self.version() == 4 and self.mask == 32) or \
                (self.version() == 6 and self.mask == 128):
            return self
        elif (self.version() == 4 and self.mask == 31) or \
                (self.version() == 6 and self.mask == 127):
            return IP(int(self) + 1, version=self.version())
        else:
            return IP(self.broadcast_long() - 1, version=self.version())

    def check_collision(self, other):
        """Check another network against the given network."""
        other = Network(other)
        return self.network_long() <= other.network_long() <= self.broadcast_long() or \
            other.network_long() <= self.network_long() <= other.broadcast_long()

    def __str__(self):
        """
        Return CIDR representation of the network.

        >>> net = Network("::1/64")
        >>> print(str(net))
        0000:0000:0000:0000:0000:0000:0000:0001/64
        """
        return "%s/%d" % (self.dq, self.mask)

    def __contains__(self, ip):
        """
        Check if the given ip is part of the network.

        >>> '192.0.2.42' in Network('192.0.2.0/24')
        True
        >>> '192.168.2.42' in Network('192.0.2.0/24')
        False
        """
        return self.check_collision(ip)

    def __lt__(self, other):
        """Compare less than."""
        return self.size() < Network(other).size()

    def __le__(self, other):
        """Compare less than or equal to."""
        return self.size() <= Network(other).size()

    def __gt__(self, other):
        """Compare greater than."""
        return self.size() > Network(other).size()

    def __ge__(self, other):
        """Compare greater than or equal to."""
        return self.size() >= Network(other).size()

    def __eq__(self, other):
        """Compare equal."""
        other = Network(other)
        return int(self) == int(other) and self.size() == other.size()

    def __getitem__(self, key):
        """Get the nth item or slice of the network."""
        if isinstance(key, slice):
            # Work-around IPv6 subnets being huge. Slice indices don't like
            # long int.
            x = key.start or 0
            slice_stop = (key.stop or self.size()) - 1
            slice_step = key.step or 1
            arr = list()
            while x < slice_stop:
                arr.append(IP(int(self) + x, mask=self.subnet()))
                x += slice_step
            return tuple(arr)
        else:
            if key >= self.size():
                raise IndexError("Index out of range: %d > %d" % (key, self.size()-1))
            return IP(int(self) + (key + self.size()) % self.size(), mask=self.subnet())

    def __iter__(self):
        """Generate a range of usable host IP addresses within the network.

        >>> for ip in Network('192.168.114.0/30'):
        ...     print(str(ip))
        ...
        192.168.114.1
        192.168.114.2
        """
        curr = int(self.host_first())
        stop = int(self.host_last())
        while curr <= stop:
            yield IP(curr)
            curr += 1

    def has_key(self, ip):
        """
        Check if the given ip is part of the network.

        :param ip: the ip address
        :type ip: :class:`IP` or str or long or int

        >>> net = Network('192.0.2.0/24')
        >>> net.has_key('192.168.2.0')
        False
        >>> net.has_key('192.0.2.42')
        True
        """
        return self.__contains__(ip)

    def size(self):
        """
        Number of ip's within the network.

        >>> net = Network('192.0.2.0/24')
        >>> print(net.size())
        256
        """
        return 2 ** ({4: 32, 6: 128}[self.version()] - self.mask)

    def __len__(self):
        return self.size()
EOF
#'

if ! declare -f log_message >/dev/null; then
    function log_message() {
        local PREV_RET_CODE=$?
        echo "$@"
        echo "$(LC_ALL=C date): $@" | LC_ALL=C perl -ne 's/\x1b[[()=][;?0-9]*[0-9A-Za-z]?//g;s/\r//g;s/\007//g;print' >>"$LOGFILE"
        if ((PREV_RET_CODE != 0)); then
            return 1
        fi
        return 0
    }
fi

if ! declare -f failed_to_install >/dev/null; then
    function failed_to_install() {
        log_message "Ericom Shield cannot be installed on this environment: $1, Exiting"
        exit 1
    }
fi

PING_REGEX='Ping:[[:space:]]([[:digit:]]+\.*[[:digit:]]*[[:space:]]*[[:alpha:]]*s)'
DL_REGEX='Download:[[:space:]]([[:digit:]]+\.*[[:digit:]]*[[:space:]]*[[:alpha:]]*\/s)'
UL_REGEX='Upload:[[:space:]]([[:digit:]]+\.*[[:digit:]]*[[:space:]]*[[:alpha:]]*\/s)'

CURL_TEST_DNS_REGEX='DNS time:[[:space:]]*([[:digit:],\.]+)'
CURL_TEST_TIME_REGEX='Total time:[[:space:]]*([[:digit:],.]+)'

DISK_CACHED_READS_REGEX='Timing cached reads:[[:print:]]*=[[:space:]]*([[:alpha:],[:space:],[:digit:],.]+\/sec)'
DISK_BUFFERED_READS_REGEX='Timing buffered disk reads:[[:print:]]*=[[:space:]]*([[:alpha:],[:space:],[:digit:],.]+\/sec)'

function print_special() {
    local TEXT="$1"
    local COLOUR="$2"
    local ATTR="$3"
    printf "\033[${ATTR};${COLOUR}m${TEXT}\033[0m\n"
}

function parse_output() {
    local OUTPUT_IN="$1"
    local REGEX="$2"
    local UNITS="$3"
    local RET=''
    if [[ $OUTPUT_IN =~ $REGEX ]]; then
        RET="$(units -tr "${BASH_REMATCH[1]}" "$UNITS")"
        echo "$RET"
        return 0
    else
        echo "\"$OUTPUT_IN\" doesn't match \"$REGEX\"" >&2
        exit 1
    fi
}

function check_range() {
    local LABEL="$1"
    local UNITS="$2"
    local LVL="$3"
    local LVL_ERROR="$4"
    local LVL_WARN="$5"
    local DIR="$6"
    local STATUS="OK"
    local RET=0

    if ((DIR == 0)); then
        if (($(echo "$LVL < $LVL_ERROR" | bc -l))); then
            STATUS="FAIL!"
            RET=1
        elif (($(echo "$LVL < $LVL_WARN" | bc -l))); then
            STATUS="WARNING!"
            RET=0
        fi
    else
        if (($(echo "$LVL > $LVL_ERROR" | bc -l))); then
            STATUS="FAIL!"
            RET=1
        elif (($(echo "$LVL > $LVL_WARN" | bc -l))); then
            STATUS="WARNING!"
            RET=0
        fi
    fi

    if [[ $STATUS == "OK" ]]; then
        echo "$LABEL: $LVL $UNITS - $(print_special "$STATUS" 32 1)"
    elif ((RET == 0)); then
        echo "$LABEL: $LVL $UNITS - $(print_special "$STATUS" 33 1) (Error level: ${LVL_ERROR} ${UNITS}, warning level: ${LVL_WARN} ${UNITS})"
    else
        echo "$LABEL: $LVL $UNITS - $(print_special "$STATUS" 31 1) (Error level: ${LVL_ERROR} ${UNITS}, warning level: ${LVL_WARN} ${UNITS})"
    fi

    return $RET
}

function parse_and_check_range() {
    local LABEL="$1"
    local UNITS="$2"
    local INPUT="$3"
    local REGEX="$4"
    local LVL_ERROR="$5"
    local LVL_WARN="$6"
    local DIR="$7"

    check_range "$LABEL" "$UNITS" "$(parse_output "$INPUT" "$REGEX" "$UNITS")" "$LVL_ERROR" "$LVL_WARN" "$DIR"
    return $?
}

function check_url_connectivity() {
    printf "\nChecking $1 ..."
    if ! LC_ALL=C curl "$1" -sS -o /dev/null -w "\nResponse Code: %{http_code}\nDNS time: %{time_namelookup}\nConnection time: %{time_connect}\nPretransfer time: %{time_pretransfer}\nStarttransfer time: %{time_starttransfer}\nTotal time: %{time_total}\n"; then
        printf "$1 check failed"
        return 1
    fi
}

function check_connectivity() {
    for url in $URLS_TO_CHECK; do
        local CHECK_OUT="$(check_url_connectivity "$url")"
        if ! (($? == 0)); then
            echo "Connectivity test failed for $url"
            return 1
        fi
        parse_and_check_range "$url DNS time" "" "$CHECK_OUT" "$CURL_TEST_DNS_REGEX" $CURL_TEST_DNS_TIME_ERROR $CURL_TEST_DNS_TIME_WARNING 1 2>&1
        parse_and_check_range "$url Total time" "" "$CHECK_OUT" "$CURL_TEST_TIME_REGEX" $CURL_TEST_TOTAL_TIME_ERROR $CURL_TEST_TOTAL_TIME_WARNING 1 2>&1
        echo ""
    done
}

function check_storage_drive_speed() {
    /sbin/hdparm -Tt $(df -l --output=source /var/lib | awk 'FNR == 2 {print $1}')
}

function check_free_space() {
    local FREE_SPACE="$(($(stat -f --format="%a*%S" $1) / (1024 * 1024 * 1024)))"
    check_range "Free space on \"$1\"" "GB" "$FREE_SPACE" $2 $3 0 2>&1
}

function check_mem() {
    local MEM_REGEX='MemTotal:[[:space:]]*([[:digit:]]+[[:print:]]+)'
    local CHECK_OUT="$(cat /proc/meminfo)"
    parse_and_check_range "Total memory" "GB" "$CHECK_OUT" "$MEM_REGEX" $MEM_AMOUNT_ERROR_GB $MEM_AMOUNT_WARNING_GB 0 2>&1
}

function check_network_address_conflicts() {
    local INTERFACES=($(find /sys/class/net -type l -not -lname '*virtual*' -printf '%f\n'))
    local INTERFACE_ADDRESSES=()

    for IFACE in "${INTERFACES[@]}"; do
        INTERFACE_ADDRESSES+=("$(/sbin/ip address show scope global dev $IFACE | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+')")
    done

    for IF_ADDR in "${INTERFACE_ADDRESSES[@]}"; do
        /usr/bin/python3 <<END
${IPCALC_PY}

if Network("${SHIELD_NETWORK_ADDR_BLOCK}").check_collision(IP("${IF_ADDR}")) :
    print("WARNING: Address collision detected: ${IF_ADDR} collides with ${SHIELD_NETWORK_ADDR_BLOCK} used by Shield!")
END
        check_ip_resolution "${IF_ADDR}" || true
    done

}

function check_ip_resolution() {
    log_message "Trying to resolve $1 to a DNS name..."
    if ! getent hosts "$1"; then
        true
        log_message "$(print_special 'WARNING:' 33 1) Could not resolve $1!"
        return 1
    else
        true
        log_message "$(print_special 'OK' 32 1)"
    fi
    return 0
}

function check_hostname_resolution() {
    local HOSTNAME="$(hostname)"
    log_message "Hostname is ${HOSTNAME}"
    log_message "Trying to resolve ${HOSTNAME} to an IP address..."
    if ! getent hosts "${HOSTNAME}"; then
        true
        log_message "$(print_special 'ERROR:' 31 1) Could not resolve ${HOSTNAME}"
        return 1
    else
        true
        log_message "$(print_special 'OK' 32 1)"
    fi
    return 0
}

function check_virt_platform() {
    VIRTUALIZATION_PLATFORM=$(
        /bin/bash <<END
${SHIELD_PRE_INSTALL_CHECK_VIRT_SH}
END
    )
    echo "$VIRTUALIZATION_PLATFORM"
}

function check_distribution() {
    local MIN_RELEASE_MAJOR="$MIN_RELEASE_MAJOR"
    local MIN_RELEASE_MINOR="$MIN_RELEASE_MINOR"
    local REC_RELEASE_MAJOR="$REC_RELEASE_MAJOR"
    local REC_RELEASE_MINOR="$REC_RELEASE_MINOR"
    local VER_REGEX="([[:digit:]]{2})\.([[:digit:]]{2})"
    local DIST_REGEX='Ubuntu'
    local DIST_S="$(/usr/bin/lsb_release -si)"
    local VER_S="$(/usr/bin/lsb_release -sr)"

    print_special "The distribution is $(/usr/bin/lsb_release -sd)" 37 1

    if ! [[ $DIST_S =~ $DIST_REGEX ]]; then
        echo "Your distribution is \"$DIST_S\" but \"$DIST_REGEX\" is required" >&2
        exit 1
    fi

    if [[ $VER_S =~ $VER_REGEX ]]; then
        VER="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
        if ((VER < ${MIN_RELEASE_MAJOR}${MIN_RELEASE_MINOR})); then
            echo "$(print_special 'ERROR:' 31 1) Your $DIST_REGEX release version is $VER_S but at least ${MIN_RELEASE_MAJOR}.${MIN_RELEASE_MINOR} is required" >&2
            exit 1
        elif ((VER != ${REC_RELEASE_MAJOR}${REC_RELEASE_MINOR})); then
            echo "$(print_special 'WARNING:' 33 1) Your $DIST_REGEX release version is $VER_S but version ${REC_RELEASE_MAJOR}.${REC_RELEASE_MINOR} is recommended" >&2
        fi
        return 0
    else
        echo "$VER_S doesn't match $VER_REGEX" >&2
        exit 1
    fi
}

function install_if_not_installed() {
    if ! dpkg -s "$1" >/dev/null 2>&1; then
        log_message "***************     $1"
        apt-get --assume-yes -y install "$1" || exit 1
    fi
}

function check_bad_kernel() {
    local BAD_KERNEL_REGEX='^4\.4\.0\-(112|113|114|115)\-.*'
    local KERNEL_VER="$(uname -r)"

    if ! [[ $KERNEL_VER =~ $BAD_KERNEL_REGEX ]]; then
        log_message "Kernel version is $KERNEL_VER - $(print_special 'OK' 32 1)"
        return 0
    else
        log_message "Kernel version is $KERNEL_VER - $(print_special 'ERROR' 31 1)"
        return 1
    fi
}

function perform_env_test() {
    local ERR=0

    install_if_not_installed lsb-release
    install_if_not_installed speedtest-cli
    install_if_not_installed hdparm
    install_if_not_installed units
    install_if_not_installed bc
    install_if_not_installed perl
    install_if_not_installed stress-ng

    log_message "Checking distribution..."
    log_message "$(check_distribution)" || ERR=1

    echo ""

    log_message "$(check_bad_kernel)" || ERR=1

    echo ""

    log_message "$(check_mem)" || ERR=1

    echo ""

    log_message "Checking free space..."
    log_message "$(check_free_space "/" $MIN_FREE_SPACE_ROOT_GB $REC_FREE_SPACE_ROOT_GB 2>&1)" || ERR=1
    if [ -d "/var/lib/docker" ]; then
        log_message "$(check_free_space "/var/lib/docker" $MIN_FREE_SPACE_DOCK_GB $REC_FREE_SPACE_DOCK_GB 2>&1)" || ERR=1
    else
        log_message "$(check_free_space "/var/lib" $MIN_FREE_SPACE_DOCK_GB $REC_FREE_SPACE_DOCK_GB 2>&1)" || ERR=1
    fi

    echo ""

    log_message "Checking Internet connectivity..."
    log_message "$(check_connectivity 2>&1)" || ERR=1

    echo ""

    log_message "Checking Internet speed..."
    # Perform Internet connection speed test
    local SPEED_TEST_OUT="$(LC_ALL=C /usr/bin/speedtest-cli --simple 2>&1)"
    log_message $(parse_and_check_range "Ping time" "ms" "$SPEED_TEST_OUT" "$PING_REGEX" $SPDTST_PING_TIME_ERROR_MS $SPDTST_PING_TIME_WARNING_MS 1 2>&1) || ERR=1
    log_message $(parse_and_check_range "Download speed" "Mbit/s" "$SPEED_TEST_OUT" "$DL_REGEX" $SPDTST_MIN_UPLOAD_SPD_MBITPS $SPDTST_WARN_UPLOAD_SPD_MBITPS 0 2>&1) || ERR=1
    log_message $(parse_and_check_range "Upload speed" "Mbit/s" "$SPEED_TEST_OUT" "$UL_REGEX" $SPDTST_MIN_DLOAD_SPD_MBITPS $SPDTST_WARN_DLOAD_SPD_MBITPS 0 2>&1) || ERR=1

    echo ""

    log_message "Checking storage drive speed..."
    local DISK_TEST_OUT="$(check_storage_drive_speed 2>&1)"
    (($? == 0)) || ERR=1
    log_message $(parse_and_check_range "Disk speed (cached reads)" "MB/sec" "$DISK_TEST_OUT" "$DISK_CACHED_READS_REGEX" $DISK_CACHED_READS_MIN_SPD_MBPS $DISK_CACHED_READS_WARN_SPD_MBPS 0 2>&1) || ERR=1
    log_message $(parse_and_check_range "Disk speed (buffered reads)" "MB/sec" "$DISK_TEST_OUT" "$DISK_BUFFERED_READS_REGEX" $DISK_BUFFERED_READS_MIN_SPD_MBPS $DISK_BUFFERED_READS_WARN_SPD_MBPS 0 2>&1) || ERR=1

    echo ""

    log_message "Checking network address conflicts..."
    check_network_address_conflicts || ERR=1

    echo ""

    check_hostname_resolution || ERR=1

    echo ""
    log_message "Checking virtualization platform..."
    log_message "$(check_virt_platform)"

    echo ""
    log_message "Gathering some system information..."
    log_message "$(docker info)"
    log_message "$(lscpu)"
    log_message "$(uptime)"
    log_message "$(uname -a)"

    echo ""
    log_message "Testing cpu performance..."
    log_message "$(stress-ng --class cpu --all 1 --metrics-brief -t60)"

    if ((ERR != 0)); then
        log_message "Exiting due to previous errors..."
        return 1
    fi
    return 0
}

if ! [[ $0 != "$BASH_SOURCE" ]]; then
    set -e
    ES_INTERACTIVE=true
    perform_env_test
    RET_VALUE=$?
    if [ $RET_VALUE != "0" ]; then
        exit 1
    fi
    log_message "shield_pre_install_check passed..."
    exit 0
fi
