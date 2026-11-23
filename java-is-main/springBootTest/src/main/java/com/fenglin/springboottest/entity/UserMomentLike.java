package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 动态点赞实体，对应数据库表 user_moment_like。
 * moment_id + user_id 唯一，保证一人对一条动态只能赞一次（可取消再赞）。
 */
@Data
@TableName("user_moment_like")
public class UserMomentLike {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 动态 id */
    private Long momentId;

    /** 点赞用户 id */
    private Long userId;

    /** 点赞时间 */
    private LocalDateTime createTime;
}
