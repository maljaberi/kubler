### kubler/glibc:20180227

Built: Tue Feb 27 15:20:49 CET 2018
Image Size: 10.7MB

#### Installed
Package | USE Flags
--------|----------
sys-apps/gentoo-functions-0.12 | ``
sys-libs/glibc-2.25-r10 | `hardened rpc -audit -caps -debug -gd -headers-only (-multilib) -nscd (-profile) (-selinux) -suid -systemtap (-vanilla)`
sys-libs/timezone-data-2017c | `nls -leaps`
#### Inherited
Package | USE Flags
--------|----------
**FROM kubler/busybox** |
sys-apps/busybox-1.28.0 | `make-symlinks static -debug -ipv6 -livecd -math -mdev -pam -savedconfig (-selinux) -sep-usr -syslog -systemd`

#### Purged
- [x] Headers
- [x] Static Libs
