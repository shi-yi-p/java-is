package com.fenglin.springboottest.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;

/**
 * 注册 JWT 拦截器：对受保护接口（/api/me、/api/profile/**、/api/social/**、/api/feedback/**）生效，
 * 公开接口 /api/register、/api/login 放行。
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private JwtInterceptor jwtInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtInterceptor)
                .addPathPatterns("/api/me", "/api/profile/**", "/api/social/**", "/api/feedback/**")
                .excludePathPatterns("/api/register", "/api/login");
    }

    /** 上传的头像等静态文件：/uploads/** -> 项目根目录下 uploads/ */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String dir = Path.of(System.getProperty("user.dir"), "uploads")
                .toAbsolutePath().normalize().toUri().toString();
        registry.addResourceHandler("/uploads/**").addResourceLocations(dir);

        // 免费授权音源：/music/** -> 前端 shayu/public/music/
        // 后端 /api/stream 会 302 到 /music/track-N.mp3（相对路径落在 8081），
        // 这里让 8081 也能直接提供同一份文件；Vite 侧同样能访问该目录。
        String musicDir = Path.of(System.getProperty("user.dir"), "..", "shayu", "public", "music")
                .toAbsolutePath().normalize().toUri().toString();
        registry.addResourceHandler("/music/**").addResourceLocations(musicDir);
    }
}
