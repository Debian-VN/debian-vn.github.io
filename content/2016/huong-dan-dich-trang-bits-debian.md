Title: Hướng dẫn dịch trang bits.debian.org
Date: 2016-04-24 10:10
Tags: huong-dan
Slug: huong-dan-dich-trang-bits-debian
Author: Giáp Trần
Status: published

[bits.debian.org](http://bits.debian.org) là trang blog chính thức của dự án Debian.

Các tin tức quan trọng luôn được cập nhật ở [bits](http://bits.debian.org).
Mỗi năm, lượng tin tức không nhiều nên công việc dịch đơn giản.

Bits sử dụng [Pelican](http://docs.getpelican.com/) để quản lý nội dung bằng markdown và tạo ra nội dung web.

## Bắt đầu dịch như thế nào?
#### **Kéo mã nguồn của bits về**
```
		git clone git://anonscm.debian.org/publicity/bits.git ~/bits
		cd ~/bits
```
#### Chúng ta thấy nội dung như sau:

```
		content/
		├── 2013
		.
		└── 2016
		    ├── debconf16-cfp.md
		    ├── debconf16-cfp-vi.md  // bản dịch tiếng việt của debconf16-cfp
		    └── results-dpl-election.md
```

		Nội dung nào chưa có tập tin chứa "-vi" là chưa được dịch.

#### Mình lấy ví dụ 1 đoạn về dịch trang [results-dpl-election.md](https://bits.debian.org/2016/04/results-dpl-elections-2016.html)


*Nội dung gốc:*

>		Title: DPL elections 2016, congratulations Mehdi Dogguy!
>		Date: 2016-04-17 18:40
>		Tags: dpl
>		Slug: results-dpl-elections-2016
>		Author: Ana Guerrero Lopez
>		Status: published
>
>		The Debian Project Leader elections finished yesterday and the winner is Mehdi Dogguy!
>		...


*Bản dịch:*

>		Title: Bầu cử lãnh đạo dự án Debian 2016, chúc mừng Mehdi Dogguy!
>		Date: 2016-04-17 18:40
>		Tags: dpl
>		Slug: results-dpl-elections-2016
>		Author: Ana Guerrero Lopez
>		Translator: Giáp Trần
>		Lang: vi
>		Status: published
>
>		Bầu cử lãnh đạo dự án Debian đã kết thúc vào ngày hôm qua và người thằng cuộc là Mehdi Dogguy!
>		...

Chỉ cần thêm 2 dòng: **Translator**(ghi danh nào) và **Lang**. Còn lại là dịch thôi.

Đấy, công việc dịch khá là đơn giản, khó nhất là ở dịch cho sát nghĩa với nội dùng nhiều từ không biết.

Nhiều từ không rõ, không biết tra ở đâu [vi.wiktionary](http://vi.wiktionary.org/) là tử điển mở do cộng đồng việt đóng góp

#### Làm sao để chạy thử web, xem lại trình bày, dịch có chuẩn không

- Sinh web và bật server

```
		make html && make devserver
```


- Trang web đã hiện có tại [127.0.0.1:8000](http://127.0.0.1:8000)

- Tắt server
```
		make stopserver
```


#### Gửi đóng góp bản dịch cho dự án Debian
- Tạo commit thôi nào
```
		git checkout vietnamese
		git add content/2016/results-dpl-election-vi.md
		git commit -m 'Add results-dpl-election translatian for Vietnamese'
```
- Gửi đóng góp

Tiếp theo là tạo bản patch và gửi về hòm thư chung của dự án dịch [debian-l10n-vietnamese](mailto:debian-l10n-vietnamese@lists.debian.org) do anh Trần Ngọc Quân điều phối.
```
		git format-patch origin/master --stdout > ban-dich-results-dpl-election.patch
```
Tạo email mới và đính kèm "ban-dich-results-dpl-election.path"
gửi tới [debian-l10n-vietnamese@lists.debian.org](mailto:debian-l10n-vietnamese@lists.debian.org)
với nội dung "gửi bản vá đóng góp bản dịch results-dpl-election".

- Hòm thư công khai tại:
[https://lists.debian.org/debian-l10n-vietnamese/](https://lists.debian.org/debian-l10n-vietnamese/)

Xin hết!
