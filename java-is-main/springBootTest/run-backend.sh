#!/usr/bin/env bash
# 启动脚本：绕过 Git Bash 下 mvn 脚本的路径问题，直接用已解压的 Maven 发行版启动 Spring Boot。
# 用法：bash run-backend.sh   （默认端口 8081，由 application-dev.properties 的 server.port 决定）
#
# 改进点（相比旧版写死 hash 的脚本）：
#   1) Maven wrapper 解压目录带随机 hash（每台机器不同），旧脚本写死 hash 会失效。
#      本脚本自动从 .mvn/wrapper/maven-wrapper.properties 读取版本号并探测实际发行版路径。
#   2) 清理会劫持 Spring Boot 端口的环境变量（SERVER__PORT / SERVER__HOST / SERVER_PORT），
#      否则后端可能被绑到非 8081 端口，导致前端 /api 代理失效。
set -e

PRJ="$(cd "$(dirname "$0")" && pwd -W)"

# ---------- 清理会劫持 Spring Boot 端口的环境变量 ----------
unset SERVER__PORT SERVER__HOST SERVER_PORT

# ---------- 自动探测 Maven wrapper 发行版路径 ----------
# 优先从 wrapper 配置读取版本号（如 apache-maven/3.9.9）
MVN_VER="3.9.9"
if [ -f "$PRJ/.mvn/wrapper/maven-wrapper.properties" ]; then
  MVN_VER="$(grep -oE 'apache-maven/[0-9.]+' "$PRJ/.mvn/wrapper/maven-wrapper.properties" | head -1 | sed 's#apache-maven/##')"
fi

# 定位 .m2 wrapper dists 目录（兼容不同环境变量）
DIST_BASE=""
for cand in "$HOME/.m2/wrapper/dists" "$USERPROFILE/.m2/wrapper/dists" "C:/Users/Administrator/.m2/wrapper/dists"; do
  if [ -d "$cand" ]; then DIST_BASE="$cand"; break; fi
done

MVN_HOME=""
CLASSWORLDS_JAR=""
if [ -n "$DIST_BASE" ]; then
  # 先按版本匹配：apache-maven-<ver>/<hash>/boot/plexus-classworlds-*.jar
  for d in "$DIST_BASE"/apache-maven-"$MVN_VER"/*/; do
    JAR="$(ls "${d}"boot/plexus-classworlds-*.jar 2>/dev/null | head -1)"
    if [ -n "$JAR" ]; then MVN_HOME="${d%/}"; CLASSWORLDS_JAR="$JAR"; break; fi
  done
  # 兜底：扫描所有 apache-maven-* 发行版
  if [ -z "$MVN_HOME" ]; then
    for d in "$DIST_BASE"/apache-maven-*/*/; do
      JAR="$(ls "${d}"boot/plexus-classworlds-*.jar 2>/dev/null | head -1)"
      if [ -n "$JAR" ]; then MVN_HOME="${d%/}"; CLASSWORLDS_JAR="$JAR"; break; fi
    done
  fi
fi

if [ -z "$MVN_HOME" ] || [ ! -f "$CLASSWORLDS_JAR" ]; then
  echo "[错误] 未找到 Maven wrapper 发行版（期望版本 $MVN_VER）。" >&2
  echo "        请先运行一次 ./mvnw 让其下载，或检查 DIST_BASE 路径。" >&2
  exit 1
fi

# 关键：Git Bash 下 $HOME 解析出的路径是 /c/Users/... 形式，
# 而 java.exe 是 Windows 进程，无法识别 /c/... 的 classpath，必须转成 Windows 路径。
MVN_HOME_W="$(cygpath -w "$MVN_HOME")"
M2_CONF_W="$(cygpath -w "$MVN_HOME/bin/m2.conf")"
CLASSWORLDS_JAR_W="$(cygpath -w "$CLASSWORLDS_JAR")"

echo "[启动] 使用 Maven: $MVN_HOME"
echo "[启动] 项目目录:   $PRJ"

exec java -cp "$CLASSWORLDS_JAR_W" \
  "-Dclassworlds.conf=$M2_CONF_W" \
  "-Dmaven.home=$MVN_HOME_W" \
  "-Dmaven.multiModuleProjectDirectory=$PRJ" \
  org.codehaus.plexus.classworlds.launcher.Launcher \
  -f "$PRJ/pom.xml" spring-boot:run -DskipTests \
  "-Dspring-boot.run.arguments=--server.port=8081"
