package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户实体，对应数据库表 user
 */
@Data
@TableName("user")
public class User {

    /** UID 基准：uid = 10000 + id，五位数起步，作为对外展示/搜索的唯一用户标识 */
    public static final long UID_BASE = 10000L;

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 账户：手机号 / 邮箱 / 用户名 */
    private String account;

    /** 密码：BCrypt 哈希密文（序列化时不暴露给前端） */
    @JsonIgnore
    private String password;

    /** 昵称 */
    private String nickname;

    /** 头像：URL 或 emoji 标识（空则前端用昵称首字母兜底） */
    private String avatar;

    /** 创建时间（数据库默认值填充） */
    private LocalDateTime createTime;

    /** 更新时间（数据库默认值填充） */
    private LocalDateTime updateTime;

    /** 逻辑删除：0-未删 1-已删 */
    @TableLogic
    private Integer deleted;

    /** UID（对外唯一标识，非数据库列，由 id 换算）：uid = 10000 + id */
    public Long getUid() {
        return id != null ? UID_BASE + id : null;
    }
}
