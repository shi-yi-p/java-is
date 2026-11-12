#!/bin/bash
# 启动后端 Spring Boot（用 Maven 发行版直接调用，规避 mvnw 在 sandbox 下的 classworlds 路径问题）
# 端口显式固定为 8081，与前端 vite /api 代理一致，避免 devtools 随机端口导致前后端失联。
set -e

# 清理会劫持 Spring Boot 端口的环境变量，确保绑定到 8081
unset SERVER__PORT SERVER__HOST SERVER_PORT

cd "D:/workSpace/java-is/java-is-main/springBootTest" || exit 1
MH="C:/Users/Administrator/.m2/wrapper/dists/apache-maven-3.9.9/977a63e90f436cd6ade95b4c0e10c20c"
CW="$MH/boot/plexus-classworlds-2.8.0.jar"

exec java -cp "$CW" \
  -Dclassworlds.conf="$MH/bin/m2.conf" \
  -Dmaven.home="$MH" \
  -Dmaven.repo.local="C:/Users/Administrator/.m2/repository" \
  -Dmaven.multiModuleProjectDirectory="D:/workSpace/java-is/java-is-main/springBootTest" \
  org.codehaus.plexus.classworlds.launcher.Launcher spring-boot:run \
  "-Dspring-boot.run.arguments=--server.port=8081 --spring.devtools.restart.enabled=false"
