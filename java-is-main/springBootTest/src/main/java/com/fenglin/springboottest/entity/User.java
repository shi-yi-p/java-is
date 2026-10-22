package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户实体，对应数据库表 user
 */
@Data
@TableName("user")
public class User {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 账户：手机号 / 邮箱 / 用户名 */
    private String account;

    /** 密码：BCrypt 哈希密文 */
    private String password;

    /** 昵称 */
    private String nickname;

    /** 创建时间（数据库默认值填充） */
    private LocalDateTime createTime;

    /** 更新时间（数据库默认值填充） */
    private LocalDateTime updateTime;

    /** 逻辑删除：0-未删 1-已删 */
    @TableLogic
    private Integer deleted;
}
