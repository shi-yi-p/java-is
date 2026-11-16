package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 登录历史实体，对应数据库表 login_history。
 * 每次成功登录 / 注册自动登录时写入一条，用于登录页「历史账户」下拉。
 */
@Data
@TableName("login_history")
public class LoginHistory {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 用户 id（关联 user.id） */
    private Long userId;

    /** 账户（手机号/邮箱/用户名） */
    private String account;

    /** 登录时昵称快照 */
    private String nickname;

    /** 登录来源 IP */
    private String ip;

    /** 登录时间 */
    private LocalDateTime loginTime;

    /** 逻辑删除：0-未删 1-已删 */
    @TableLogic
    private Integer deleted;
}
