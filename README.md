# Sao lại có 2 nhánh  khác nhau hoàn toàn?
- generate: nhánh dùng quản trị nội dung markdown. output => nhánh master
- master: nhánh nội dung html. Hiển thị ra [debian-vn.github.io](http://debian-vn.github.io)

_**Vì vậy không bao giờ trộn 2 nhánh lại với nhau!**_
# Đây là gì?
Là môi trường phát triển, quản lý trang [debian-vn.github.io](http://debian-vn.github.io)

Các bài viết dùng Markdown => hiển thị thành web

Sử dụng công cụ  [Pelican](http://docs.getpelican.com/)

## Cài đặt các gói phụ thuộc
```
$sudo pip install pelican markdown
```
## Sao chép nguồn về
```
$git clone --recursive --branch generate git@github.com:Debian-VN/debian-vn.github.io.git
$cd  ~/debian-vn-generate
```
