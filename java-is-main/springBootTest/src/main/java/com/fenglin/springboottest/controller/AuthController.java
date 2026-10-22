package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.JwtUtil;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.AuthRequest;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * 认证接口：注册 / 登录
 * 路径前缀 /api 与前端 shayu 约定一致
 */
@RestController
@RequestMapping("/api")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    /**
     * 注册：POST /api/register
     * 成功 200；账户已存在 409；参数不合法 400
     */
    @PostMapping("/register")
    public ResponseEntity<Result<Void>> register(@RequestBody AuthRequest req) {
        String account = req.getAccount();
        String password = req.getPassword();

        // 基础校验（前端已校验，后端再次兜底）
        if (account == null || account.isBlank() || password == null || password.length() < 8) {
            return ResponseEntity.badRequest()
                    .body(Result.fail(400, "账户或密码格式不正确（密码至少 8 位）"));
        }

        // 查重
        if (userService.accountExists(account)) {
            return ResponseEntity.status(409)
                    .body(Result.fail(409, "该账户已被注册 🐟"));
        }

        // 写入（密码哈希 + 昵称）
        userService.register(account, password, req.getNickname());
        return ResponseEntity.ok(Result.ok("注册成功！欢迎加入鲨鱼音乐 🦈🎵"));
    }

    /**
     * 登录：POST /api/login
     * 成功 200 并返回 token；账户或密码错误 401
     */
    @PostMapping("/login")
    public ResponseEntity<Result<Map<String, String>>> login(@RequestBody AuthRequest req) {
        User user = userService.login(req.getAccount(), req.getPassword());
        if (user == null) {
            return ResponseEntity.status(401)
                    .body(Result.fail(401, "账户或密码错误"));
        }

        // 生成 JWT（7 天有效期，账户名作为 subject）
        String token = jwtUtil.generateToken(user.getAccount());
        Map<String, String> data = new HashMap<>();
        data.put("token", token);
        data.put("account", user.getAccount());
        return ResponseEntity.ok(Result.ok("登录成功 🎶", data));
    }

    /**
     * 获取当前登录用户：GET /api/me
     * 需携带 Authorization: Bearer <token>，由 JwtInterceptor 校验并设置 account 属性
     */
    @GetMapping("/me")
    public ResponseEntity<Result<Map<String, String>>> me(HttpServletRequest request) {
        String account = (String) request.getAttribute("account");
        User user = userService.lambdaQuery().eq(User::getAccount, account).one();
        Map<String, String> data = new HashMap<>();
        data.put("account", account);
        data.put("nickname", user != null ? user.getNickname() : "");
        return ResponseEntity.ok(Result.ok("已登录", data));
    }
}
