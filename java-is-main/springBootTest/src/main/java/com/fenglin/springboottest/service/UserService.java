package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.fenglin.springboottest.entity.User;

/**
 * 用户服务接口
 */
public interface UserService extends IService<User> {

    /**
     * 判断账户是否已存在
     */
    boolean accountExists(String account);

    /**
     * 注册新用户（密码以 BCrypt 哈希存储）
     *
     * @return 注册成功返回 true；账户已存在返回 false
     */
    boolean register(String account, String password, String nickname);

    /**
     * 登录校验
     *
     * @return 校验通过返回用户；账户不存在或密码错误返回 null
     */
    User login(String account, String password);
}
