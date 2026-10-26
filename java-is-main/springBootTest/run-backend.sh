#!/usr/bin/env bash
# 启动脚本：绕过 Git Bash 下 mvn 脚本的路径问题，直接用已解压的 Maven 发行版启动 Spring Boot。
# 用法：bash run-backend.sh   （默认端口 8081，由 application-dev.properties 的 server.port 决定）
set -e

MVN_HOME="C:/Users/Administrator/.m2/wrapper/dists/apache-maven-3.9.9/3477a4f1"
PRJ="$(cd "$(dirname "$0")" && pwd -W)"

exec java -cp "$MVN_HOME/boot/plexus-classworlds-2.8.0.jar" \
  "-Dclassworlds.conf=$MVN_HOME/bin/m2.conf" \
  "-Dmaven.home=$MVN_HOME" \
  "-Dmaven.multiModuleProjectDirectory=$PRJ" \
  org.codehaus.plexus.classworlds.launcher.Launcher \
  -f "$PRJ/pom.xml" spring-boot:run -DskipTests \
  "-Dspring-boot.run.arguments=--server.port=8081"
