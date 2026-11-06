package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 听歌总排名榜用户条目：用户 + 累计听歌时长 + 等级 + 排名。
 */
@Data
public class RankUserVO {

    /** 排名（从 1 开始） */
    private int rank;

    private Long userId;

    private String nickname;

    /** 头像首字母 */
    private String avatarLetter;

    /** 累计听歌时长（秒） */
    private long listenSeconds;

    /** 播放次数 */
    private long playCount;

    /** 鲨鱼等级 */
    private int level;

    /** 等级名称 */
    private String levelName;
}
