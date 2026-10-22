package com.fenglin.springboottest.common;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;

/**
 * JWT 工具：生成与校验 token。
 * 说明：演示用固定密钥，生产环境请改为环境变量 / 配置中心下发，且密钥长度至少 256 位（HS256）。
 */
@Component
public class JwtUtil {

    private static final String SECRET = "shark-music-jwt-secret-key-please-change-in-prod-2026";
    private static final long EXPIRE_MS = 7L * 24 * 60 * 60 * 1000; // 7 天

    private final SecretKey key = Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));

    /** 生成 token，账户名作为 subject */
    public String generateToken(String account) {
        Date now = new Date();
        Date exp = new Date(now.getTime() + EXPIRE_MS);
        return Jwts.builder()
                .subject(account)
                .issuedAt(now)
                .expiration(exp)
                .signWith(key)
                .compact();
    }

    /** 解析 token 拿到账户名（无效则抛异常） */
    public String parseAccount(String token) {
        Claims claims = Jwts.parser()
                .verifyWith(key)
                .build()
                .parseSignedClaims(token)
                .getPayload();
        return claims.getSubject();
    }

    /** 校验 token 是否有效 */
    public boolean validate(String token) {
        try {
            parseAccount(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
