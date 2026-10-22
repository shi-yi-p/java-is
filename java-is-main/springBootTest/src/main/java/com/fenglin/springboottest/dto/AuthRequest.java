package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 注册 / 登录请求体，对应前端传入的 { account, password }
 */
@Data
public class AuthRequest {
    private String account;
    private String password;
    /** 昵称（注册时可选，不填则默认与账户相同） */
    private String nickname;
}
