package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 历史账户视图对象，返回给登录页「历史账户」下拉。
 */
@Data
public class LoginHistoryVO {

    /** 账户（手机号/邮箱/用户名） */
    private String account;

    /** 昵称（最近一次登录时的快照） */
    private String nickname;

    /** 最近一次登录时间 */
    private String loginTime;
}
