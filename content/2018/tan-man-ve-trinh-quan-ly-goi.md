Title: Tản mạn về trình quản lý gói
Date: 2018-04-28
Tags: apt, dpkg, thu-thuat
Slug: tan-man-ve-trinh-quan-ly-goi
Author: Giáp Trần
Status: draft

Nhắc đến một bản Distro, có lẽ người ta sẽ quan tâm về `Triết lý`, `Kiến trúc` và `Trình quản lý gói` của Distro đó.

Bài viết hôm này mình sẽ chia sẻ về trình quản lý gói của Debian, được đánh giá là trình quản lý gói mạn mẽ. À mình chỉ tản mạn về cách mình hay sử dụng với góc nhìn của một sysadmin cũng như người dùng ưu tìm tòi. Còn nâng cao thì mình nghĩ tài liệu chính thức từ Debian đã viết rất đầy đủ

## Sơ qua các gói

- dpkg

Bao gồm các công cụ
```
└>dpkg -L dpkg |grep bin/
/usr/bin/dpkg
/usr/bin/dpkg-deb
/usr/bin/dpkg-divert
/usr/bin/dpkg-maintscript-helper
/usr/bin/dpkg-query
/usr/bin/dpkg-split
/usr/bin/dpkg-statoverride
/usr/bin/dpkg-trigger
/usr/bin/update-alternatives
```
Viết tắt của `D`ebian `P`ac`K`a`G`e, nó sẽ quản lý tất cả các vấn đề liên quan tới package trên máy của bạn

- apt

Bao gồm các công cụ
```
└>dpkg -L apt | grep bin/
/usr/bin/apt
/usr/bin/apt-cache
/usr/bin/apt-cdrom
/usr/bin/apt-config
/usr/bin/apt-get
/usr/bin/apt-key
/usr/bin/apt-mark
```

Viết tắt của `A`dvanced `P`ackaging `T`ool

- apt-file
```
└>dpkg -L apt-file | grep bin/
/usr/bin/apt-file
```

Không viêt tắt nữa, gói này cho phép chúng ta tìm kiếm các gói có trong repo bằng các đường dẫn tệp tệp


Còn có rất nhiều gói hỗ trợ về package như `aptitude`,`software-properties-common`,`apt-transport-https`,...

## Đôi điều về định dạng *.deb

- Ở góc nhìn tệp nén bình thưòng, chúng ta có thể giải nén bằng `ar` (cung cấp bởi gói `binutils`)
```
└>ar t dpkg_1.18.24_amd64.deb
debian-binary      # version của địng dạng gói *deb
control.tar.gz     # Toàn bộ tệp nằm trong DEBIAN giúp hỗ trợ về cài đặt, gỡ bỏ gói và thông tin các phụ thuộc
data.tar.xz        # Toàn bộ dữ liệu của chương trình, là một thư mục / giả để caì vào / thật
```
- Mở bằng dpkg-deb
```
dpkg-deb  -R dpkg_1.18.24_amd64.deb tree
```
Giải nén vào thư mục `tree`, trong thự mục này tương tự nhưng data.tar.xz đã giải nén vào, và control.tar.gz thì giải nén vào thư mục con `tree/DEBIAN`


### Dùng mà không cần cài trực tiếp
Vì thế nếu bạn không muốn cài đặt các chương trình trực tiếp lên máy (hoặc không có quyền root), cách đơn giản là bạn download tệp deb về và giải nén bằng `dpkg-deb` (ưu tiên hơn) vào một thư mục nào đó rồi dùng trực tiêp.

Tất nhiên bạn phải có khả năng xử lý các vấn đề xung quanh nếu gói đó yêu cầu các thư viện phụ thuộc, cấu hình gì đó, hoặc nó yêu cầu quyền root. Các gói đơn giản thì chỉ cần bung lụa ra là có thể chạy


Nếu chương trình `dpkg` gặp lỗi hay hư hỏng, quá đơn giản để download `dpkg.deb` về và dùng lệnh giải nén `ar` để giải nén vào thẳng `/`. Đây là một điểm rất hay, `dpkg` chỉ phụ thuộc vào thư viện rất tối giản, mình nhớ không nhầm thì chỉ cần `busybox` là đủ

## Đôi điều với dpkg

`dpkg` quản lý mọi vấn đề về package ở trên máy bạn. Bao gồm cài đặt, cấu hình, gõ bỏ,... Tức là chỉ quản lý các gói đã cài, hoặc cài các gói mới bằng tệp `package.deb` chứ không biết gì về các kho phần mềm online.


### 1. dpkg -l (--list)

Lệt kê toàn bộ gói trên hệ thống

- mình hay dùng cái này để grep xem máy mình đã cài cắm cái gì rồi

Ví dụ:

```
└>dpkg -l | grep dpkg
ii  dpkg                                        1.18.24                                 amd64        Debian package management system
ii  dpkg-dev                                    1.18.24                                 all          Debian package development tools
ii  libdpkg-perl                                1.18.24                                 all          Dpkg perl modules
```
- Hoặc kiểm tra xem gói nào đã gỡ nhưng vẫn tồn tại cấu hình, tức đã `remove` mà chưa `purge`

```
└>dpkg -l | awk '/^rc/'
rc  dnssec-trigger                              0.13-6                                  amd64        reconfiguration tool to make DNSSEC work
rc  irssi                                       1.0.2-1+deb9u3                          amd64        terminal based IRC client
rc  resolvconf                                  1.79                                    all          name server information handler
```

Và có thể purge ngay `sudo dpkg -P $(dpkg -l | awk '/^rc/ {print $2}')` hoặc `sudo apt-get purge $(dpkg -l | awk '/^rc/ {print $2}')`

### 2. dpkg -L (--listfiles)
Bạn có thể thấy ngay ở mục giới thiệu các gói mình sử dụng `dpkg -L`. Dùng để lệt kê toàn bộ tệp tin có trong 1 gói.

Tính năng này giúp chúng ta xem xét trong 1 gói có những tệp thực thi, cấu hình, thư viện nào?

Ví dụ
```
└>dpkg -L dpkg | grep var/
/var/lib
/var/lib/dpkg
/var/lib/dpkg/alternatives
/var/lib/dpkg/info
/var/lib/dpkg/parts
/var/lib/dpkg/updates

```
Lưu ý: Có những gói sinh thêm các tệp cấu hình trong quá trình cài đặt hay runtime, và nó không được liệt kê bởi `dpkg -L`


### 3. dpkg -S (--search)

Đồng nghiệp thấy mình đang dùng `xrandr` (mình chuyển để chuyển VGA =)) ) liển hỏi cái cái lệnh `xrandr` ở đâu.

Câu trả lời là `dpkg -S xrandr` ra 1 đống liên quan tới `*xrandr`

```
└>dpkg -S xrandr
bash-completion: /usr/share/bash-completion/completions/xrandr
libxrandr2:amd64, libxrandr2:i386: /usr/share/doc/libxrandr2
libxrandr2:amd64, libxrandr2:i386: /usr/share/doc/libxrandr2/changelog.gz
x11-xserver-utils: /usr/bin/xrandr
```

Nên cách tốt nhất là mình gõ ngay ```dpkg -S `which xrandr` ```

```
└>dpkg -S `which xrandr`
x11-xserver-utils: /usr/bin/xrandr
```


### 3. dpkg -s (--status)

Sau khi hắn cài xong `x11-xserver-utils` nhưng `xrandr` của hắn không chuyển VGA được (do chưa biết dùng =]]] ), hắn quay sang hỏi mình dùng phiên bản gói nào.

Mình gõ ngay

```
└>dpkg -s x11-xserver-utils
Package: x11-xserver-utils
Status: install ok installed
Priority: optional
Section: x11
Installed-Size: 516
Maintainer: Debian X Strike Force <debian-x@lists.debian.org>
Architecture: amd64
Source: x11-xserver-utils (7.7+7)
Version: 7.7+7+b1
...
```

Lưu ý: đây chỉ là version gói thôi nhá, thường nó tương đương với version của công cụ đối với các gói chỉ cung cấp một công cụ duy nhất (thường thôi nhé).

Ví dụ như
```
└>xrandr --version
xrandr program version       1.5.0
Server reports RandR version 1.5
```

## Đôi điều với apt

`apt` ngoài việc xử lý các công việc như dpkg để cài cắm, cấu hình, gõ bỏ gói trên máy bạn thì apt còn cần phải quan tâm đến các kho package online mà chúng ta thường thêm bớt ở `/etc/apt/source*`

Như vậy để apt biết các gói nằm ở đâu thì cái này do ở bạn

Apt cung cấp rất nhiều công công để thực hiện các bước khác nhau. Mình hay sử dụng `apt-key`,`apt-get`, `apt-cache`

### 1. apt-cache policy

Lệnh này check xem 1 gói đang có những phiên bản ở các kho nào

```
└>apt-cache policy base-files
base-files:
  Installed: 9.9+deb9u4
  Candidate: 10.0.0-1.1
  Version table:
     10.0.0-1.1 500
        500 https://devrepo.subgraph.com/subgraph aaron/main amd64 Packages
 *** 9.9+deb9u4 500
        500 http://deb.debian.org/debian stretch/main amd64 Packages
        100 /var/lib/dpkg/status
     9.9+deb9u2 500
        500 http://deb.debian.org/debian stretch-updates/main amd64 Packages
```

Trên máy mình base-files đang có 3 phiên bản cung cấp bởi 3 kho khác nhau, vào chỉ có phiên bản `9.9+deb9u4` là đang được cài đặt

### 2. apt-cache madison

Lệnh này chỉ liệt kê các thông tin về phiên bản, kho của tên gói hoặc gói nguồn.
```
└>apt-cache madison base-files
base-files | 10.0.0-1.1 | https://devrepo.subgraph.com/subgraph aaron/main amd64 Packages
base-files | 9.9+deb9u4 | http://deb.debian.org/debian stretch/main amd64 Packages
base-files | 9.9+deb9u2 | http://deb.debian.org/debian stretch-updates/main amd64 Packages
base-files | 9.9+deb9u4 | http://deb.debian.org/debian stretch/main Sources
base-files | 9.9+deb9u2 | http://deb.debian.org/debian stretch-updates/main Sources
```
Hiển thị thêm 2 gói nguồn từ `stretch/main` và `stretch-updates/main`

### 3. apt-cache depends

Lệnh này mình hay sử dụng để xem 1 gói nó phụ thuộc vào các gói nào, qua đó có chút mường tượng ra cách hoạt động và độ phức tạp của nó
```
└>apt-cache depends htop
htop
  Depends: libc6
  Depends: libncursesw5
  Depends: libtinfo5
  Suggests: lsof
  Suggests: strace
```

### 4. apt-get changelog

Debian bản stable rất ít khi cập nhật phần mềm theo upstream mà chỉ cập nhật các bản vá là chính, vì thế mà mình hay tò mò đã có gì thay đổi khi update 1 gói.

```
└>apt-get changelog apt
apt (1.4.8) stretch; urgency=medium

  [ Balint Reczey ]
  * Gracefully terminate process when stopping apt-daily-upgrade (LP: #1690980)
...
```
### 5. apt-get source
Tò mò qua changelog vẫn chưa đủ, thi thoảng mình kéo cả mã nguồn của nó về để cập nhật những gì

```
apt-get source ibus-unikey
```

Với cách kéo mã nguồn này thì bạn chỉ có thể xem sự thay đổi so vơí upstream thôi, vì Debian sẽ lưu trữ nhưng bản vá so với phiên bản upstream vào trong thư mục `debian/patches`

Lưu ý: Để làm việc với các mã nguồn của gói thì trong /etc/apt/source* phải cấu hình thêm `deb-src`. Ví dụ

```
deb-src http://deb.debian.org/debian/ stretch main
```
### 6. apt-cache showsrc

Vì thế mà câu lệnh này giúp chúng ta lấy mã nguồn được maintain ở đâu.

```
└>apt-get source apt
Reading package lists... Done
NOTICE: 'apt' packaging is maintained in the 'Git' version control system at:
https://anonscm.debian.org/git/apt/apt.git
```

## Đôi điều với apt-file

Nhắc tới `apt-cache` thì câu lệnh đầu tiên đánh ra mình phải liệt kê là `apt-cache search`, nhưng cái này tìm chán lắm. Không đáp ứng được nhu cầu của mình nên mình đã tìm hiểu và biết thêm về `apt-file`

Sau khi cài gói `apt-file`, nó yêu cầu mình phải cập nhật để nó có thông tin mà tìm kiếm bằng `apt-file update` kiểu như `apt-get update`

### apt-file search

Đồng nghiệp đang ngồi xem `hack wifi với aircrack`. Nhìn thấy youtuber gõ `airmon-ng start balabốnla`, thấy vậy hắn gõ ngay  `apt-get install airmon-ng`

```
dongnghiep#apt-get install airmon-ng
Reading package lists... Done
Building dependency tree
Reading state information... Done
E: Unable to locate package airmon-ng
```

Đây là lúc mà siêu nhân sysadmin ra tay, mình gõ ngay trên máy mình

```
└>apt-file search bin/airmon-ng
aircrack-ng: /usr/sbin/airmon-ng
```

Rồi bảo hắn "tools này thuộc gói aircrack-ng", hắn liền gõ ngay `apt-get install aircrack-ng` không cần mình nói gì thêm

### apt-file list

dpkg -L dùng để list toàn bộ tệp trong 1 gói ĐÃ CÀI, đó mà lý do chúng ta cần cái chức năng này để liệt kê các tệp có trong gói mà ta cài hay chưa nó không quan tâm

```
apt-file list aircrack-ng
```

## Đôi điều về kho phần mềm
Việc sử dụng `apt-*` phụ thuộc vào kho phần mềm online mà bạn đang cài đặt. Các kho phần mềm trong `/etc/apt/source*`

Ví dụ máy bạn nào chưa có kho phần mềm cuả docker thì apt-* không biêt gì về gói `docker-ce` chẳng hạn.

Ngoài ra Ubuntu cung cấp thêm các kho PPA riêng cho nguời dùng, ngưòi sử dụng chỉ cần gõ `add-apt-repository`, kho ppa có ưu điểm cung cấp thêm nhiều kho phần mềm khác nhau cho người dùng. Nhưng cũng có nhược điểm là các kho ppa mang tính cá nhân cao, thường không có đảm bảo về mã nguồn. Nên phải dùng PPA tin cậy

```
└>apt-file search bin/add-apt-repository
software-properties-common: /usr/bin/add-apt-repository
```
