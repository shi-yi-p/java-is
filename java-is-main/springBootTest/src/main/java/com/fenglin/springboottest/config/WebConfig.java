package com.fenglin.springboottest.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 注册 JWT 拦截器：对受保护接口（/api/me、/api/profile/**、/api/social/**）生效，
 * 公开接口 /api/register、/api/login 放行。
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private JwtInterceptor jwtInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/api/me", "/api/profile/**", "/api/social/**")
                .excludePathPatterns("/api/register", "/api/login");
    }
}
