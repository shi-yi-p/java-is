package com.fenglin.springboottest.config;

import com.fenglin.springboottest.common.JwtUtil;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * JWT 拦截器：对受保护接口（如 /api/me）校验 Authorization: Bearer <token>。
 * 校验通过后将账户名与用户 id 一并写入 request 属性，供控制器直接读取，
 * 避免各控制器重复执行「account → 查库 → id」的冗余查询。
 */
@Component
public class JwtInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserService userService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 预检请求放行，由 CORS 配置处理
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String header = request.getHeader("Authorization");
        if (header == null || !header.startsWith("Bearer ")) {
            writeUnauthorized(response, "未登录或 token 缺失");
            return false;
        }

        String token = header.substring(7);
        String account;
        if (!jwtUtil.validate(token)) {
            writeUnauthorized(response, "token 无效或已过期");
            return false;
        }
        account = jwtUtil.parseAccount(token);

        request.setAttribute("account", account);

        // 一次性解析用户 id，避免每个控制器再重复查库（account → id）
        User user = userService.lambdaQuery().eq(User::getAccount, account).one();
        request.setAttribute("userId", user != null ? user.getId() : null);
        return true;
    }

    private void writeUnauthorized(HttpServletResponse response, String message) throws Exception {
        response.setStatus(HttpStatus.UNAUTHORIZED.value());
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"code\":401,\"message\":\"" + message + "\"}");
    }
}
