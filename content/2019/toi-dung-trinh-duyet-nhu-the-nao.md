Title: Tôi đang dùng trình duyệt như thế nào?
Date: 2019-04-16
Tags: chia-se
Slug: toi-dung-trinh-duyet-nhu-the-nao
Author: Giáp Trần
Status: published

Ngày nay ai cũng dùng trình duyệt web mỗi ngay, có thể nói khi nhắc tới Internet là hầu như mọi người nghĩ đến lướt web. Và chúng ta có vô số chương trình để lướt web gọi là Trình duyệt web (browser). 

Bài này nó lên quan điểm cá nhân nên mình chỉ để cập tới 2 browser mà mình đang dùng là `Firefox` và `Chromium`.

## I. Mình dùng khác gì mọi người, sao tận 2 cái?
Mình dùng để làm việc và đọc tin tức, không khác mọi người.

`Firefox` là trình duyệt yêu thích và là mặc định của mình, còn `Chromium` vẫn dùng khá nhiều o.O ?

## II. Chia sẻ gì trong bày này.
Điểm hay mà mình muốn chia sẻ hôm nay, chỉ là sự tối ưu về mặt làm việc. (Có thể nó không hay với bạn)

Ngày nay chúng ta làm rất nhiều việc trên browser nên đôi khi mình thấy 1 bạn nào đó mở hơn chục tabs trên 1 cái trình duyệt. Có vài bạn biết sắp xếp hơn bằng cách tạo ra các profile khác nhau như Ngân hàng, Làm việc, Mạng xã hôị, Hội nguời cùng khổ,...

Đấy cái chính hôm nay là mình chia sẻ việc tạo ra các profile linh động dùng trên các Distro Linux bằng lệnh thuận tiện.


### Firefox

Mình gọi script là `w2`

```bash
#!/bin/bash                                                       
[ "${DEBUG:-0}" -eq 1 ] && set -x

OPTS=""
if [ $# -gt 1 ]; then
    OPTS="--private-window"
fi
firefox -P "$1" $OPTS
```

Với `w2` chúng ta có thể gọi Firefox ra với một profile nhanh chóng

Ví dụ:
![w2]({static}/images/w2.png)

- `w2 bank` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Mở Firefox ra với profile là `bank`, nếu chưa có thì chúng ta sẽ tạo 1 lần
- `w2 bank .` &nbsp; Mở ẩn danh của `bank` profile

Điểm hay của Firefox:

- Bạn có thể cấu hình proxy riêng cho mỗi profile trực tiếp trên chính trình duyệt. Chromium thì phải qua dòng lệnh với tham số cụ thể.

### Chromium

Mình gọi script là `w3`

```bash
#!/bin/bash
[ "${DEBUG:-0}" -eq 1 ] && set -x

OPTS=""

_help(){
    echo "Usage: w3 [-p] [-c] [-d] PROFILE"
    echo "Profiles:${profiles}"
}

for opt in "$@"; do
    if [[ "$opt" == [-]* ]]; then
        case ${opt:1:1} in
            p) PRIVATE=0 ;;
            c) CREATE=0 ;;
            d) DELETE=0 ;;
            -)
                case ${opt:2} in
                    create) CREATE=0 ;;
                    private) PRIVATE=0 ;;
                    delete) DELETE=0 ;;
                esac;;
        esac
    else
        args_string+="$IFS$opt"
    fi
done

args=($args_string)
profile_name=${args[0]}

[ $PRIVATE ] && OPTS="--incognito"

profiles=" "
for dir in $HOME/.config/chromium/profile*; do
    name=$(basename $dir)
    profiles="${name##*profile.} $profiles"
done
profiles=" $profiles"

if [ -z "$profile_name" ]; then
    _help
    exit 1
fi

# If --delete is set
if [ $DELETE ]; then
    if [[ "$profiles" == *" ${profile_name} "* ]];then
        rm -rf "${HOME}/.config/chromium/profile.${profile_name}"
    fi
    exit 0
fi

# If --create is not set, check the exist before start
if [ ! $CREATE ]; then
    if [[ ! "$profiles" == *" ${profile_name} "* ]];then
        _help
        exit 1
    fi
fi

# Start one is default
chromium --args --profile-directory="profile.$profile_name" "$OPTS"
```

Với `w3` chúng ta có thể tạo mới, mở ra hoặc xoá một profile

Ví dụ:

![w3]({static}/images/w3.png)

- `w3 bank -c` &nbsp;&nbsp; Tạo profile mới tên là bank
- `w3 bank`    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Mở profile là bank
- `w3 bank -p` &nbsp;&nbsp; Mở profile  là bank ở chế độ ẩn danh
- `w3 bank -d` &nbsp;&nbsp; Xoá profile với tên là bank

Điểm hay của Chromium:

- Chỉ cần truyền đối số thẳng mà không cần tạo bẳng tay (đó là lý do mình cần viêt thêm tuỳ chọn `-c`)

### Temp profile của Chromium
Đây thật sự là một tính năng tuyệt vời.
Ví dụ bạn cần test một ứng dụng chat nhóm với 3,4 người tham gia cùng 1 lúc. Đây chính là lúc bạn cần nhiều profile trình duyệt để độc lập về session (phiên làm việc)

Chúng ta có thể dùng `w2` và `w3` để tạo ra nhiều profile nhưng điều đó là không hay vì chúng ta chỉ sử dụng tạm thời.

Chromium cung cấp tuỳ chọn `--temp-profile` để có thể mở ra một profile hoàn toàn mới, và được xoá khi tắt browser.

- `chromium --temp-profile`

- `chromium --temp-profile --incognito` &nbsp;&nbsp; Mình thật sự dùng cái này, vì cái icon không xoay xoay gân tốn thời gian =))

Và Chrome của Google cũng cung cấp tính năng không khác gì Chromium nhé.

## III. Tổng kết
Mỗi người sẽ có kiểu dùng của mỗi người, đây là cách mà mình dùng browser. Thành thật thì nó sẽ không nhanh cho những ai không thích dùng lệnh. Hiện tại mình đang dùng `dmenu` (chính xác là `i3-dmenu-desktop`) để gọi ứng dụng nên nó thật sự rất hiệu qủa.
