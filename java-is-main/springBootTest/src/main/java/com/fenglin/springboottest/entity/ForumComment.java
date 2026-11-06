package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 论坛评论实体，对应数据库表 forum_comment
 */
@Data
@TableName("forum_comment")
public class ForumComment {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 所属帖子 id */
    private Long postId;

    /** 评论用户 id */
    private Long userId;

    /** 评论内容 */
    private String content;

    /** 点赞数 */
    private Long likes;

    private LocalDateTime createTime;

    /** 逻辑删除 */
    @TableLogic
    private Integer deleted;
}
