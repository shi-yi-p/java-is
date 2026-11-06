package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 论坛帖子视图对象：帖子基础信息 + 发帖人昵称 + 格式化时间，便于前端直接展示。
 */
@Data
public class ForumPostVO {

    private Long id;
    private Long userId;
    private String title;
    private String content;
    private String category;
    private long likes;
    private long comments;
    private long views;

    /** 发帖人昵称 */
    private String nickname;

    /** 发帖人头像首字母 */
    private String avatarLetter;

    private String createTime;
}
