package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 聊天室消息视图对象：消息内容 + 发送人昵称 + 格式化时间。
 */
@Data
public class ChatMessageVO {

    private Long id;
    private Long userId;
    private String content;

    /** 发送人昵称 */
    private String nickname;

    /** 发送人头像首字母 */
    private String avatarLetter;

    private String createTime;
}
