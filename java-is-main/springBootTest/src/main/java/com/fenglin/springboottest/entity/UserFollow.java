package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户关注关系实体，对应数据库表 user_follow
 */
@Data
@TableName("user_follow")
public class UserFollow {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 关注者用户 id（粉丝） */
    private Long followerId;

    /** 被关注用户 id */
    private Long followeeId;

    /** 关注时间 */
    private LocalDateTime createTime;

    /** 逻辑删除：0-未删 1-已删 */
    @TableLogic
    private Integer deleted;
}
