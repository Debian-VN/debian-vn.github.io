Title: Cài đặt Debian từng bước một bằng lệnh
Date: 2016-08-28 17:43
Tags: huong-dan
Slug: cai-dat-debian-tung-buoc-mot-bang-lenh
Author: Giáp Trần
Status: published

**Cài Debian từng bước một là sao?**

Không phải next next (*trình cài đặt nhanh*) là xong sao?

Bạn đã nghe một số distro với triết lý tinh chỉnh nhiều vào hệ thống,
các distro này không cung cấp *trình cài đặt nhanh* mà muốn người phải cài đặt bằng tay (VD: Arch Linux)

Bài hướng dẫn hôm nay trình bày các bước cài đặt Debian bằng tay với 1 bản livecd,
mang đến góc nhìn mới về cài đặt một bản distro, và hiểu hơn bản chất của việc cài đặt.

Việc cài đặt gồm 3 bước chính:

1. Tạo file hệ thống vào phân vùng
2. Cài đặt kernel, initrd và bootloader
3. Cài các gói cấn thiết (sudo, kết nối mạng), thêm user

Chú ý: Trong phần câu lệnh:

- Với $ dành cho user thường trên máy local
- Còn # là quyền root sau khi đã chroot vào /mnt (Chroot là gì? Hồi sau sẽ rõ)
## Chuẩn bị
Cần chuẩn bị:

- 1 bản Livecd [debian-live-8.5.0-amd64-standard.iso](http://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/)
- 1 cái máy để cài

Mình sử dụng KVM để demo. Với giả định là máy chưa có phân vùng nào.

Nếu cài vào phân vùng khác thì tương tự.
## I. Tạo hệ thống file vào phân vùng OS

#### Chọn chế độ livecd và login vào tài khoản
```
  login: user
  pass: livecd
```
*P/S: Đối với bản livecd mình đưa link trên*
#### 1. Chia phân vùng

- /dev/sda1 7GB phân vùng cho OS
- /dev/sda2 1GB cho swap

```
  $sudo cfdisk /dev/sda
```


![cfdisk]({filename}/images/cfdisk.png)

Format phân vùng cài OS
```
  $sudo mkfs.ext4 /dev/sda1
```

Format swap
```
  $sudo mkswap /dev/sda2
```

#### 2. Mount /dev/sda1 vào /mnt

Mục đích là cài đặt hệ thống file vào thư mục này

```
  $sudo mount /dev/sda1 /mnt
```

#### 3. Cài đặt `debootstrap`

```
  $sudo apt-get install debootstrap -y
```

**Debootstrap** là script có chức năng tạo ra hệ thống file Debian.

Có thể bạn không biết nhưng **debootsrap** được dùng rất nhiều.

*Ví dụ:* tạo ra [base image: Debian](https://hub.docker.com/_/debian) dùng cho Docker

Nó là 1 công cụ rất tuyệt vời.

Mỗi distro thường sẽ có 1 tool có chức năng như thế này: VD: Arch linux là `pacstrap`

#### 4. Cài đặt hệ thống file cho Debian

```
  $sudo debootstrap stable /mnt http://debian.xtdv.net/debian
```

Lệnh này sẽ:

- cài bản stable (hiện là bản jessie 8.5)
- vào thư mục /mnt
- với mirror từ debian.xtdv.net (Mirror này ở việt nam dùng rất nhanh)

![debootstrap]({filename}/images/debootstrap.png)

Bạn có thể  gõ `man debootstrap` hay `debootstrap --help` để rõ hơn

debootstrap hỗ trợ cả cài đặt Ubuntu và cũng có trên Ubuntu
## II. Cài đặt boot cho OS
Sau khi đã có hệ thống file cho OS.
![ls-mnt]({filename}/images/ls-mnt.png)

Việc cần làm tiếp theo là phải làm sao boot được cái OS này lên.
Vậy chúng ta cần:

- Kernel linux
- Initrd file
- Bootloader (grub, lilo,..)

Để cài đặt 3 phần trên, chúng ta cần phải mount bind các thư mục hệ thống local vào `/mnt` và `chroot` để tiến hành cài đặt

#### 1. Mount các thư mục của hệ thống local vào /mnt
```
  $sudo mount -o bind /proc /mnt/proc
  $sudo mount -o bind /sys /mnt/sys
  $sudo mount -o bind /dev /mnt/dev
  $sudo chroot /mnt
  #
```
![mount]({filename}/images/mount.png)
#### 2. Cài đặt các gói
##### *Cài đặt kernel và initrd*

Tìm gói chứa kernel và initrd
```
  #apt-cache search linux-image
  linux-headers-3.16.0-4-amd64 - Header files for Linux 3.16.0-4-amd64
  linux-image-3.16.0-4-amd64 - Linux 3.16 for 64-bit PCs
  linux-image-3.16.0-4-amd64-dbg - Debugging symbols for Linux 3.16.0-4-amd64
  linux-image-amd64 - Linux for 64-bit PCs (meta-package)
  linux-image-amd64-dbg - Debugging symbols for Linux amd64 configuration (meta-package)
```
Kernel phiên bản 3.16. Tiến hành cài đặt
```
  #apt-get install linux-image-3.16.0-4-amd64 -y
```


##### *Cài đặt GRUB*
```
  #apt-get install grub2 -y
```
![grub]({filename}/images/grub.png)

## III. Cấu hình hệ thống, cài đặt cái gói cần thiết

#### 1. Viết file hệ thống /etc/fstab
Sao phải viết file này?

Grub boot hệ thống thì nó sẽ đọc /boot/grub/grub.cfg và boot ngon lành cơ mà.

Ừ, thì nó boot ngon lành, nhưng cầu hình file này để mount chính xác hệ thống của mình, không là Grub sẽ mount / chỉ readonly

Và nếu bạn có thư mục /home, /usr ở phân vùng hay thư mục riêng thì cần phải viết file này để hệ thống nó mount lúc boot.

##### *Lây UUID của phân vùng chứa OS (ở đây là /dev/sda1)*
```
#ls -la /dev/disk/by-uuid/
```
![ls-dev-disk-by-uuid]({filename}/images/ls-dev-disk-by-uuid.png)
Chúng ta thấy được UUID của /dev/sda1 là `2c0f6023-c802-4640-a8ce-214d079b22c9`

##### *Cấu hình vào /etc/fstab*
```
#cat > /etc/fstab << EOF
UUID=2c0f6023-c802-4640-a8ce-214d079b22c9	/	ext4	defaults	0	0
EOF
```
#### 2. Cài sudo, và tạo user mới (ví dụ user test)
```
#apt-get install sudo -y
useradd -s /bin/bash -m test
passwd test
adduser test sudo
```

#### 3. Đặt password cho root (tùy chọn)
```
  #passwd
```
#### 4. Cài các gói bạn cần.

Ở bước này (tức là đã mout proc,sys,dev vào mnt và chroot)

Bạn hoàn toàn có thể sử dụng cài đặt luôn các desktop enviroment, windown manager hay các gói khác.

VD: cài Gnome3, Mate, KDE, i3,...

Mình khuyết khích cài các gói liên quan tới connect mạng để tý nữa login vào OS có thể vào mạng được mà cài cắm tiếp.


## Kết thúc
Như vậy là đã xong toàn bộ quá trình cài đặt 1 OS Debian mới tinh vào /dev/sda1.

Cần umount `/mnt/{sys,proc,dev,}` và reboot lại máy để dùng nữa thôi.
#### 1. Thoát Chroot
```
  #exit
  $
```
#### 2. Umount và reboot
```
  $sudo umount /mnt/proc /mnt/sys /mnt/dev /mnt
  $sudo reboot
```
![umount]({filename}/images/umount.png)


#### 3. Thành quả
![debian-boot]({filename}/images/debian-boot.png)

![debian-login-test]({filename}/images/debian-login-test.png)
