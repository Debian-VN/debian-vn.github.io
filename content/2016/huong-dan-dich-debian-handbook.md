Title: Hướng dẫn đóng góp bản dịch Debian Administrator's Handbook
Date: 2016-04-24 18:26
Tags: huong-dan
Slug: huong-dan-dong-gop-ban-dich-debian-handbook
Author: Giáp Trần
Status: published

[The Debian Administrator's Handbook](https://debian-handbook.info/) được viết bởi hai nhà phát triển _Raphaël Hertzog_ và _Roland Mas_. Là một quyển sách cầm tay hay gối đầu giường tuyệt vời cho tất cả người dùng các bản phân phối dựa trên Debian.

Cuốn sách này dạy các yếu tố cần thiết cho bất cứ ai muốn trở thành một quản trị viên [Debian GNU/Linux](https://www.debian.org) hiệu quả và độc lập.

## Tiến hành dịch như thế nào?
#### **Kéo mã nguồn của sách về**
```
		git clone https://github.com/Debian-VN/debian-handbook ~/debian-handbook
		cd ~/debian-handbook
```
#### Chúng ta thấy nội dung như sau:

```
.
├── ja-JP
├── vi-VN
│   ├── 00a_preface.po
│   ├── 00b_foreword.po
.   .   ...
.   .   ...
```
Và chỉ cần quan tâm các tập tin ở trong thư mục [vi-VN](https://github.com/Debian-VN/debian-handbook/tree/master/vi-VN) thôi.
#### Mình sẽ dịch 1 đoạn trong phần _00a_preface_ của quyển sách này
```
# TxGVNN <txgvnn@gmail.com> 2016
# Tên <email> năm-dịch
msgid ""
msgstr ""
"Project-Id-Version: 0\n"
"POT-Creation-Date: 2015-10-01 20:53+0200\n"
"PO-Revision-Date: 2015-10-01 20:53+0200\n"
"Last-Translator: Automatically generated\n"
"Language-Team: Debian-VN\n"
"Language: vi-VN \n"
"MIME-Version: 1.0\n"
"Content-Type: application/x-publican; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
"X-Generator: Publican v4.3.2\n"

msgid "Preface"
msgstr "Lời nói đầu"
```

 - Đầu tiên hãy thêm tác giả dịch cho chính mình bằng chú thích # TÊN EMAIL NĂM_DỊCH.
 - Dịch các thông tin trong bản gốc **msgid** và điền vào **msgstr**.

#### Gửi đóng góp bản dịch
- Tạo commit thôi
```
		git add vi-VN/00a_preface.po
		git commit -m 'vi-VN: translate first line in 00a_preface'
```
_Chú ý là commit thì bắt đầu bằng **vi-VN:** để các bạn nước khác còn biết mà phân biệt nhé_.

- Đẩy lên github
```
	git push origin master
```

Như vậy là xong
#### [Tuỳ chọn] Bạn muốn build thử pdf,html hay epub để xem.
- Cài đặt môi trường, tool để build
```
		sudo apt-get install dblatex texlive-xetex publican publican-debian
```
- Build thôi
```
		cd ~/debian-handbook
		./build/build-pdf --lang="vi-VN"		#build only pdf
		./build/build-html --lang="vi-VN"		#build only html
```
Còn để build epub còn 1 số gói phụ thuộc nữa.
