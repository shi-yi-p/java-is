package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.service.UserService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

    /**
     * 注册：事务保证 + 写后回查校验，确保数据真正落库。
     * 若 save 返回 false（未写入）或回查不到记录，抛出异常回滚，绝不"假成功"。
     */
    @Override
    @Transactional
    public User register(String account, String password, String nickname) {
        // 注册查重
        if (accountExists(account)) {
            return null;
        }
        User user = new User();
        user.setAccount(account);
        // 密码哈希后存储，绝不保存明文
        user.setPassword(encoder.encode(password));
        // 昵称：前端有传则用，否则默认与账户相同
        user.setNickname(nickname != null && !nickname.isBlank() ? nickname.trim() : account);

        // 写入：save 返回 false 说明没插入成功，立即报错
        boolean saved = save(user);
        if (!saved) {
            throw new IllegalStateException("用户写入失败，请稍后重试");
        }

        // 写后回查：从数据库重新读一次，确认记录真实存在且拿到自增 id
        User persisted = lambdaQuery()
                .eq(User::getAccount, account)
                .one();
        if (persisted == null) {
            throw new IllegalStateException("用户写入后回查失败，数据未持久化");
        }
        return persisted;
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
