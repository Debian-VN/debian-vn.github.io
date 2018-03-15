# [debian-vn.github.io](http://debian-vn.github.io)
`Blogs of Debian VN. Clone from bits.debian.org`

# Sao lại có 2 nhánh  khác nhau hoàn toàn?
- **generate**: nhánh dùng quản trị nội dung markdown. output => nhánh master
- **master**: nhánh nội dung html. Hiển thị ra [debian-vn.github.io](http://debian-vn.github.io)

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
$cd  ~/debian-vn-github.io
```
## Viết bài, chạy thử và phát hành
```
content/
├── 2016
│   ├── cai-dat-debian-tung-buoc-mot-bang-lenh.md
│   ├── huong-dan-dich-debian-handbook.md
```

#### Viết bài mới

```
vi content/2016/bai-viet-moi.md
```

#### Chạy thử và kiểm nghiệm

```
make devserver
```
- Website đã khả dụng ở [127.0.0.1:8000](http://127.0.0.1:8000)

#### Dừng chạy
```
make stopserver
```

#### Và đăng nội dụng mới lên github
- Tạo html vả đẩy html lên nhánh **master** (nhánh master ở thư mục output, chứ không checkout sang master)
```
make html
cd output
git add *
git commit -m 'add new bai-viet-moi.html'
git push origin master
```
- Đẩy markdown tới nhánh **manager** lên

```
cd -
git add content/bai-viet-moi.md
git commit -m 'add content/content/bai-viet-moi.md'
git push origin manager
```
