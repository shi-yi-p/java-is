package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 论坛评论视图对象：评论内容 + 评论人昵称 + 格式化时间。
 */
@Data
public class ForumCommentVO {

    private Long id;
    private Long postId;
    private Long userId;
    private String content;
    private long likes;

    /** 评论人昵称 */
    private String nickname;

    /** 评论人头像首字母 */
    private String avatarLetter;

    private String createTime;
}
