package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 论坛帖子实体，对应数据库表 forum_post
 */
@Data
@TableName("forum_post")
public class ForumPost {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 发帖用户 id */
    private Long userId;

    /** 帖子标题 */
    private String title;

    /** 帖子正文 */
    private String content;

    /** 帖子板块：music 音乐分享 / chat 闲聊灌水 / song 歌单推荐 / sing 唱歌达人 / story 听歌故事 / help 求助问答 */
    private String category;

    /** 点赞数 */
    private Long likes;

    /** 评论数 */
    private Long comments;

    /** 浏览数 */
    private Long views;

    private LocalDateTime createTime;

    /** 逻辑删除 */
    @TableLogic
    private Integer deleted;
}
