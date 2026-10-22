package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.service.UserService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

/**
 * 用户服务实现
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    @Override
    public boolean accountExists(String account) {
        return lambdaQuery()
                .eq(User::getAccount, account)
                .count() > 0;
    }

    @Override
    public boolean register(String account, String password, String nickname) {
        // 注册查重
        if (accountExists(account)) {
            return false;
        }
        User user = new User();
        user.setAccount(account);
        // 密码哈希后存储，绝不保存明文
        user.setPassword(encoder.encode(password));
        // 昵称：前端有传则用，否则默认与账户相同
        user.setNickname(nickname != null && !nickname.isBlank() ? nickname.trim() : account);
        return save(user);
    }

    @Override
    public User login(String account, String password) {
        User user = lambdaQuery()
                .eq(User::getAccount, account)
                .one();
        if (user == null) {
            return null;
        }
        // 比对 BCrypt 哈希
        if (!encoder.matches(password, user.getPassword())) {
            return null;
        }
        return user;
    }
}
