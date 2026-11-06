package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 用户动态实体，对应数据库表 user_moment
 */
@Data
@TableName("user_moment")
public class UserMoment {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 用户 id */
    private Long userId;

    /** 动态类型：listen / favorite / create_playlist / follow */
    private String type;

    /** 动态文本 */
    private String content;

    /** 关联歌曲 id（可选） */
    private Long songId;

    /** 关联歌单 id（可选） */
    private Long playlistId;

    /** 发布时间 */
    private LocalDateTime createTime;

    /** 逻辑删除：0-未删 1-已删 */
    @TableLogic
    private Integer deleted;
}
