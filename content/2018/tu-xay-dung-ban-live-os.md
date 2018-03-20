Title: Xây dựng bản Live từ Debian cho riêng bạn
Date: 2018-03-15
Tags: huong-dan
Slug: tu-xay-dung-ban-live-os
Author: Giáp Trần
Status: published

**Live OS** không khác gì một hệ điều hành thông thường, nhưng nó thường được dùng tạm thời là chính, và được cài đặt trong chiếc USB nhỏ gọn. Mọi dữ liệu sinh ra trong quá trình sử dụng sẽ không được lưu lại khi tắt hệ thống. Nó có thể khởi động trên bất kỳ máy tính nào khi cắm vào (tất nhiên phải cùng kiến trúc vi xử lý nha)

Qua thời gian dùng [TxGVNN/live-os](https://github.com/TxGVNN/live-os/) của chính mình một thời gian, hôm nay mình chia sẻ cách tạo ra bản live-os cho riêng các bạn từ kinh nghiệm tào lao của mình -_-

## Sao phải dùng?
Tuỳ mục đính của bạn. Với mình, bản live chứa các công cụ mình cần để làm việc và giải trí, có thể cắm vào máy công ty, ở nhà và bạn bè để dùng 1 cách thoải mái.
Ví dụ, chúng ta đi đâu mà không mang PC/Laptop theo, mà lại cần nó để làm cái gì đó, với chiếc USB có chứa bản live-os, quá dễ dàng để ta làm điều đó bằng cách mượn máy tính nhưng không mượn hệ điều hành. Hơhơ =))

Hay đôi khi là cứu cánh cho các máy tính GNU/Linux OS lỗi boot hoặc chuyển phân vùng các kiểu. Thậm chí là 1 bản chuyên cài Linux dạo :P

Ngoài ra, chúng ta có các bản live cho các mục đích đặc biệt:

- [Tails - Privacy for anyone anywhere](https://tails.boum.org) Nghe tên đã rõ.
- [Kali Linux Live](https://docs.kali.org/category/downloading) Cho người cần công cụ từ Kali.

Hiện mình đang sử dụng cả 2 OS này nữa để mutil-boot với bản live-os của mình.

## Cần công cụ gì?

Debian cung cấp công cụ [live-build](http://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html)
 
Công cụ này là tập hợp các kịch bản giúp tạo ra một bản live từ cơ bản đến phức tạp bằng cách hỗ trợ rất tốt trong việc chinh tỉnh bản live theo ý bạn muốn. _Đó là lý do mình gọi là **bản live-os cho riêng bạn**_. 


Các bản distro based Debian chắc vẫn sẽ kế thừa tools này (Ubuntu). Má thật, Debian làm tốt quá, không có cơ hội đóng góp (chém giooó)

### Cài cắm công cụ

```
sh# apt-get install live-build
```

Chúng ta có thể thấy `live-build` phụ thuộc vào `debootstrap`, công cụ chuẩn của Debian mà mình đã dùng trong bài viết [Cài đặt Debian từng bước một bằng lệnh](/2016/08/cai-dat-debian-tung-buoc-mot-bang-lenh.html)

Như vậy bạn có thể hiểu ngay, `live-build` sử dụng `debootstrap` để tạo ra một hệ điều hành mới vào 1 thư mục nào đó, rồi thực hiện `chroot` vào trỏng để xử lý cài đặt và tinh chỉnh thêm, đại loại là thế.

## I. Quá trình xây dựng cơ bản
Tạo 1 thư mục để làm việc ở đó.

```
    sh# mkdir ~/live-os && cd ~/live-os
```

### 1. Tạo cấu hình cơ bản

**Cách 1:** Sinh cấu hình cơ bản mặc định (không khuyến khích)


```
    sh# lb config
```

Sau khi chạy lệnh này, chúng ta sẽ thấy ít nhất 2 thư mục là `auto`,`config` được tạo ra. 

- `auto` là thư mục chứa các script sẽ là được `lb` đọc để thực thi các tham số cấu hình thay vì mặc định
- `config` là toàn bộ cấu hình mặc định.

**Cách 2:** Clone cấu hình cơ bản các loại từ nhóm phát triển `live-team` (quá khuyến khích)

```
    sh# git clone git://anonscm.debian.org/debian-live/live-images.git --branch debian /tmp/live-images
    
```
- Gòm có các loại cấu hình như sau 
    
```
    sh# ls /tmp/live-images/images/ -1
```
```
    cinnamon-desktop
    gnome-desktop
    kde-desktop
    lxde-desktop
    mate-desktop
    standard
    xfce-desktop
```
    
Ở đây mình sẽ lấy cái `standard` (chưa cài đặt GUI)
```
    sh# cp /tmp/live-images/images/standard/* ~/live-os/ -av
```

### 2. Tạo tệp iso

Sau đó chúng ta chỉ việc chạy

```
    sh# lb build
```

Nó sẽ tự động thực hiện tất cả công đoạn và cuối cùng tạo ra các tệp tin dành cho live.

Như file `filesystem.squashfs`, `vmlinuz`, `initrd.gz` hay `*.iso`


### 3. Tạo boot vào USB

Giả sử `/dev/sdc` là đường dẫn của USB sau khi chúng ta cắm vô.
Thực hiện sao chép dữ liệu từ iso sang USB.

```
    sh# dd if=<file>.iso of=/dev/sdc
```

### 4. Boot hệ điều hành live

Cắm USB vào, bật máy tính và truy cập vào `Boot menu` trên máy tính, cuối cùng chọn boot từ USB.



## II. Tinh chỉnh bản live cho riêng bạn

Ở bước 1, tạo cấu hình, chúng ta có nhiều cách để tinh chỉnh OS theo ý của mình.

#### 1. `auto/config` là tệp cấu hình các tham số khi chúng ta thực hiện `lb config`

Mọi người có thêm xem các tham số chi tiết bằng `man lb_config`

Ví dụ:
Cấu hình với Debian phiên bản 9(stretch) trên cấu trúc `amd64` và mirror Vietnam cho tốc độ nhanh.

```bash
_ARCH="amd64"
_MIRROR="http://debian.xtdv.net/debian"
_DIST="stretch"

lb config noauto \
	--verbose \
	--architecture "${_ARCH}" \
	--distribution "${_DIST}" \
    --apt-source-archives "false" \
	--archive-areas "main contrib non-free" \
	--linux-packages "linux-image linux-headers" \
	--mirror-binary "${_MIRROR}" \
	--mirror-chroot "${_MIRROR}" \
	--mirror-bootstrap "${_MIRROR}" \
    "${@}"
```

### 2. Cài đặt packages cần thiết và tuỳ chọn cho bạn
Bằng cách thêm danh sách gói mới vào tệp tin mới (đuôi `.list.chroot`) trong thư mục `config/package-lists/`

Ví dụ:
```
sh# head -n3 config/package-lists/txgvnn.list.chroot
```
```
cryptsetup
i3
xinit
```

### 3. Cài đặt các cấu hình chi tiết cho môi trường, phần mềm

Mình nghĩ có 2 kiểu, **cấu hình tĩnh** (tức là cứng vào OS luôn) và **cấu hình động** (tức chỉ cấu hình lúc boot bản live lên)

#### - Đối với cấu hình tĩnh - Thường áp dụng cho cầu hình hệ thống

Chúng ta chỉ cần copy thằng vào `config/includes.chroot/` và xem đây là thư mục gốc (`/`) của bản live.

Ví dụ: Mình muốn tắt cái tiếng beep như *beep* trong terminal.

```
sh# mkdir config/includes.chroot/etc/modprobe.d/ -p
sh# echo "blacklist pcspkr" > config/includes.chroot/etc/modprobe.d/nobeep.conf
```

#### - Đối với cấu hình động - Thường áp dụng cho cầu hình người dùng

Chúng ta sẽ viết các script thực hiện việc cấu hình mỗi khi bản live được boot. Công việc này sẽ được thực hiện bởi `live-boot`.

`live-build` sẽ cài đặt `live-boot` (hỗ trợ boot bản live) và `live-config{-system}` (hỗ trợ các cấu hình cơ bản cho bản live). Các gói này được liệ kê tự động ở `config/package-lists/live.list.chroot`.

Ví dụ để thêm cấu hình `i3` window manager cho mình. [includes.chroot/lib/live/config/0075-i3-config](https://github.com/TxGVNN/live-os/blob/master/config/includes.chroot/lib/live/config/0075-i3-config)

Vì `live-boot` sẽ liệt kê các script theo thứ tự trong thư mục `/live/live/{boot,config}` nên các bạn hay chú ý đến số thứ tự sẽ tốt hơn cho việc cấu hình. Như cái nào config trước, cái nào sau.

### 4. Hook

Được xem là các kịch bản chỉnh sửa hệ thống khi nó đang trong quá trình tạo ra hệ thống.
Bạn có thể xem các kịch bản sẽ được thực hiện ở `config/hooks/`. Đây là các hook mặc định từ `live-build`, bạn có thể thêm mới nếu bạn có ý tưởng gì đó.


Ví dụ: Bản live của mình có cài tor, nhưng mình không muốn nó luôn khởi động khi boot. Vì thế mình đã tạo ra 1 hook nhằm disable nó. [live-os/config/hooks/live/0100-update-rc.d.hook.chroot](https://github.com/TxGVNN/live-os/blob/master/config/hooks/live/0100-update-rc.d.hook.chroot)


### 5. Còn nhiều cái nữa để biến ý tưởng vào bản live.

Chi tiết mọi người có thể đọc tại [Live Systems Manual](http://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html)

Bản thân mình còn sử dụng thêm 1 phân vùng nằm trên USB gọi là `persistence store` nhằm lưu trữ các dữ liệu cá nhân. Lý do là live-os sẽ xoá toàn bộ dữ liệu sinh ra trong quá trình sủ dụng sau khi tắt nó.

Ngoài ra với phân vùng này mình sử dụng `cryptsetup` để mã hoá toàn bộ phân vùng, sẽ là tuyệt để lưu trữ dữ liệu cá nhân nhưng vẫn cho bạn bè, đồng nghiệp mượn bản `live` vô tư. Tính năng này có sẵn trong `Tails OS`, đây thật sự là bản live rất tốt.

## III. Dual-boot hoặc mutil-boot cùng các bản live khác

Vấn đề này nảy sinh khi mình tham lam muốn có thể boot 3 bản live khác nhau trong 1 cái USB (16 GB) gồm: Debian, Tails OS và Kali.

### 1. Mình sử dụng chương trình `Tails Installer` (viết bằng `Python`) do `Tails` cung cấp. 

Chương trình này sẽ chia USB thành 2 phân vùng như sau

```
    /dev/sdc         16   GB     # Tổng
    |-/dev/sdc1      2.5  GB     # Tất cả OS và bootloader
    |-/dev/sdc2      13.5 GB     # Phân vùng dữ liệu riêng, sẽ mã hoá bằng LUKS
```

Tức nó sẽ chia 1 phân vùng mặc định `2.5 GB` cho cả bản Live. Bạn có thể sửa giá trị này trong `/usr/lib/python2.7/dist-packages/tails_installer/config.py`. Mình sửa thành `3300 MB` để có thể chứa được 3 OS.

Sau đó nó sẽ tạo boot cho `Tails OS` vào USB và toàn bộ hệ điều hành nằm ở `/dev/sdc1` 
Bây giờ mình có thể boot live hệ điều hành này rồi.

### 2. Thêm Debian live vào cùng
Mình thực hiện `lb build` để build bản live của mình. Sau khi kết thúc, trong thư mục `binary/live` có 3 tệp tin quan trọng là `vmlinuz`, `initrd.img` và `filesystem.debian.squashfs`


Copy 3 tệp tin này vào `/dev/sdc1` như sau:
```
sh# mount /dev/sdc1 /mnt
sh# cp binary/live/vmlinuz /mnt/live/vmlinuz.debian
sh# cp binary/live/initrd.img /mnt/live/initrd.debian.img
sh# cp binary/live/filesystem.squashfs /mnt/live/filesystem.debian.squashfs

```
Tạo thông tin cho Debian live

```
sh# echo "filesystem.debian.squashfs" > /mnt/live/Debian.module
```


Thêm thông tin boot cho Debian live

Thêm vào 4 tệp tin (mình thấy chỉ cần 2 cái `live64.cfg` là đủ)
```
    - /mnt/EFI/BOOT/live{,64}.cfg      # 2 cho EFI boot (32 và 64)
    - /mnt/syslinux/live{,64}.cfg      # 2 cho Legacy boot (32 và 64)
```
như sau:
```
label livedebian
        menu label Debian
        kernel /live/vmlinuz.debian
        append initrd=/live/initrd.debian.img boot=live module=Debian timezone=Asia/Ho_Chi_Minh components splash quiet
```

Đối với `Kali live` thì tương tự.

Sau đó 
```
sh# umount /mnt
```
Và boot hưởng thành quả

### ? Nếu bạn muốn mutil-boot mà muống dùng Tails Installer để bắt đầu
Ví dụ các bạn dùng `dd` để tạo boot từ tệp iso. Mình vẫn nghĩ có thể làm theo cách trên.
