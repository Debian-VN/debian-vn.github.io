Title: An toàn và bảo mật với DNS
Date: 2018-12-28
Tags: huong-dan
Slug: an-toan-va-bao-mat-voi-dns
Author: Giáp Trần
Status: published

**DNS** (viết tắt trong tiếng Anh của Domain Name System - Hệ thống tên miền) là một hệ thống cho phép thiết lập tương ứng giữa địa chỉ IP và tên miền trên Internet. (Nguồn [vi.wikipedia](https://vi.wikipedia.org/wiki/Domain_Name_System))

Trong bài này mình sẽ hướng dẫn thiết lập 2 tính năng cho hệ thống Debian giúp những truy vấn DNS của máy tính được _An toàn với DNSsec_ và _Bảo mật với DNScrypt_

[DNSSEC](https://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions) ra đời nhằm đảm bảo các câu trả lời DNS là chính xác, còn [DNSCRYPT](https://dnscrypt.info/implementations/) thì mã hoá các kết nối DNS thông thường bằng cách kết hợp các công nghệ khác như DNS over HTTP, DNS over TLS...

## I. Sao phải dùng?

### DNSSEC
>Tránh bị khai thác vào giao thức DNS như trả về địa chỉ sai cho truy vấn DNS. Mặc dù HTTPS là đảm bảo bạn được cảnh báo nhưng có người vẫn cố tình truy cập thế mới là vấn đề.

### DNSCRYPT
>Tránh bị nghe lén, theo dõi các truy vấn tên miền của bạn từ người xấu, nhà cung cấp dịch vụ mạng. Chắc cũng phần nào thôi, vì nếu bọn xấu cao tay hơn thì theo dõi theo địa chỉ IP, lúc đó bạn cần phải tay cao hơn. [Tor chăng?](https://www.eff.org/pages/tor-and-https)

## II. Thiết lập từng dịch vụ

### DNSSEC
Debian cung cấp gói `unbound`, theo như mô tả thì
```
sh# apt-cache show unbound
...
Description-en: validating, recursive, caching DNS resolver
 Unbound is a recursive-only caching DNS server which can perform DNSSEC
 validation of results...

```
Sau khi cài xong với `apt-get install unbound` chúng ta sẽ có 2 service là

- `systemctl status unbound` chạy chương trình unbound, nó sẽ tạo ra DNS server tại địa chỉ `127.0.0.1:53` cho bạn.
- `systemctl status unbound-resolvconf` với mục đích cập nhật `/etc/resolv.conf` một cách tự động.

#### Kiểm thử
Để kiểm tra xem DNSSEC đã hoạt động hay chưa, thử truy vấn thông tin dnssec từ địa chỉ _dnssec.cz_.
Nếu cờ `ad` xuất hiện là đã truy vấn DNSSEC thành công, hãy tìm hiểu các cờ nhé.

Chúng ta sẽ so sánh một chút.

```
# TRUY VẤN VỚI DNS Server được cấp phát tự động
└>dig @192.168.0.1 +dnssec A dnssec.cz | grep -E 'ad|SERVER:' # check flags: ad
;; SERVER: 192.168.0.1#53(192.168.0.1)

# TRUY VẤN VỚI Unbound
└>dig @127.0.0.1 +dnssec A dnssec.cz | grep -E 'ad|SERVER:' # check flags: ad
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1
;; SERVER: 127.0.0.1#53(127.0.0.1)

# TRUY VẤN VỚI Google
└>dig @8.8.8.8 +dnssec A dnssec.cz | grep -E 'ad|SERVER:' # check flags: ad
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1
;; SERVER: 8.8.8.8#53(8.8.8.8)

# TRUY VẤN VỚI Cloudflare
└>dig @1.1.1.1 +dnssec A dnssec.cz | grep -E 'ad|SERVER:' # check flags: ad
;; flags: qr rd ra ad; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1
;; SERVER: 1.1.1.1#53(1.1.1.1)
```

Như bạn có thể thấy, kết quả trả về từ máy chủ nhà cung cấp không hỗ trợ DNSSEC. Còn Google và Cloudflare có hỗ trợ DNSSEC, nên đơn giản bạn có thể sử dụng 2 nhà cung cấp này.

Nhưng phần tiếp theo mình cài cắm DNSCRYPT và sẽ là tuyệt nếu tích hợp với Unbound

### DNSCRYPT
Debian cung cấp gói `dnscrypt-proxy`, tương tự chúng ta có:
```
sh# apt-cache show dnscrypt-proxy
...
Description-en: Tool for securing communications between a client and a DNS resolver
 dnscrypt-proxy provides local service which can be used directly as your local
 resolver or as a DNS forwarder, encrypting and authenticating requests using
 the DNSCrypt protocol and passing them to an upstream server...
```
Sau khi cài xong `apt-get install dnscrypt-proxy` chúng ta sẽ có 2 service là

- `systemctl status dnscrypt-proxy` để chạy chương trình dnscrypt-proxy, nó sẽ tạo ra DNS server tại địa chỉ `127.0.2.1:53` cho bạn. Và không xung đột địa chỉ vơí Unbound (127.0.0.1)
- `systemctl status dnscrypt-proxy-resolvconf` với mục đích cập nhật `/etc/resolv.conf` một cách tự động.

Đặc điểm của DNScrypt là bạn phải chọn một máy chủ cung cấp dịch vụ này, danh sách này có ở `/usr/share/dnscrypt-proxy/dnscrypt-resolvers.csv`.
Bạn có thể chọn 1 trong số đó và cấu hình vào `/etc/dnscrypt-proxy/dnscrypt-proxy.conf`, nó sẽ trông như thế này.

```
ResolverName ipredator
Daemonize no
LocalAddress 127.0.2.1:53
```

Có 1 điểm khá bất tiện, là đôi khi máy chủ DNScrypt không truy cập được. Nên bạn phải tìm và đổi sang máy chủ khác bằng tay. Vì thế bạn nên viết 1 kịch bản có thể tìm và thay tự động cho bạn.

Ví dụ như `/usr/local/bin/dnscrypt-update`

``` sh
#!/bin/bash
[ "${DEBUG:-0}" -eq 1 ] &&  set -x

FILE="/usr/share/dnscrypt-proxy/dnscrypt-resolvers.csv"
LOG="$(mktemp -t .dnsproxy.XXXX)"
total=$( wc -l< "$FILE")

msg(){ printf "%s: %s\n" "$1" "$2";}

echo "" > "$LOG"
while ! grep Proxying "$LOG"; do
    select=$(( RANDOM %= total ))
    choice=$(cut -f1 -d',' < "$FILE" | sed "$select"'q;d')
    msg "I" "Try $choice"
    dnscrypt-proxy --resolver-name="$choice" --local-address=127.0.3.1:53 >& "$LOG" &
    PID=$!
    sleep 10
    kill "$PID"
done

msg "I" "Choose $choice"
sed -i 's/ResolverName.*/ResolverName '"$choice/" /etc/dnscrypt-proxy/dnscrypt-proxy.conf

```
#### Testing
Để có thể dễ dàng quan sát, hãy đảm bảo không có ứng dụng nào đang hoạt động mà cần kết nối mạng.

Ví dụ mình đang sử dụng wifi với interface là `wpl3s0`, chúng ta sẽ sử dụng tcpdump để theo dõi kết nối vào cổng UDP/53 như sau

```
└>sudo tcpdump -n -i wlp3s0 udp port 53
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlp3s0, link-type EN10MB (Ethernet), capture size 262144 bytes
```

##### 1. Thử nghiệm với lệnh `192.168.0.1`

Kết quả lệnh:
```
nslookup gnu.org 192.168.0.1
Server:         192.168.0.1
Address:        192.168.0.1#53

Non-authoritative answer:
Name:   gnu.org
Address: 208.118.235.148
```
Và từ tcpdump
```
... IP 192.168.0.186.38101 > 192.168.0.1.53: 55790+ A? gnu.org. (28)
... IP 192.168.0.1.53 > 192.168.0.186.38101: 55790 1/0/0 A 208.118.235.148 (41)
```

##### 2. Thử nghiệm với `1.1.1.1`

```
└>nslookup gnu.org 1.1.1.1
Server:         1.1.1.1
Address:        1.1.1.1#53

Non-authoritative answer:
Name:   gnu.org
Address: 208.118.235.148
```

Và từ tcpdump

```
... IP 192.168.0.186.40491 > 1.1.1.1.53: 58978+ A? gnu.org. (28)
... IP 1.1.1.1.53 > 192.168.0.186.40491: 58978 1/0/0 A 208.118.235.148 (41)
```

##### 3. Thử nghiệm với `127.0.2.1`

```
└>nslookup gnu.org 127.0.2.1
Server:         127.0.2.1
Address:        127.0.2.1#53

Non-authoritative answer:
Name:   gnu.org
Address: 208.118.235.148
```

Và từ tcpdump là rỗng. Bởi vì dnscrypt-proxy đã truy vấn tới máy chủ đã cấu hình không qua giao thức UDP/53 như thông thường. Hãy tìm hiểu thêm chi tiết nhé.

## III. Tích hợp DNSsec và DNScrypt

Như vậy chúng ta đã có 2 dịch vụ DNS lắng nghe ở hai địa chỉ

- `127.0.0.1#53` Giải quyết bài toán an toàn (DNSsec)
- `127.0.2.1#53` Giải quyết bài toán bảo mật (DNScrypt)

Máy tính sẽ sử dụng địa chỉ được cấu hình trong `/etc/resolv.conf` để truy vấn tên miền.

Chúng ta sẽ cấu hình để truy vấn DNSsec sẽ đi qua DNScrypt bằng cách tạo tệp `/etc/unbound/unbound.conf.d/dnscrypt.conf` với nội dung:

```
server:
        do-not-query-localhost: no
forward-zone:
        name: "."
        forward-addr: 127.0.2.1@53
```

Và không cho dnscrypt cập nhật vào `/etc/resolv.conf` bằng cách `systemctl stop dnscrypt-proxy-resolvconf`

Kết quả

```
└>cat /etc/resolv.conf
# Generated by resolvconf
nameserver 127.0.0.1
```

Như vậy là hệ thống của bạn mỗi lần kết nối mạng và phân giải tên miền một cách an toàn và bảo mật hơn với DNSsec và DNScrypt. Hãy tìm hiểu 2 từ khoá trên để hiểu rõ hơn về chúng.
