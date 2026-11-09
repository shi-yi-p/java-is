package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 播放历史聚合结果（数据库 GROUP BY 后返回），用于听歌排行榜。
 * 字段名与 SQL 别名一一对应，由 MyBatis 自动映射。
 */
@Data
public class ListenAgg {

    /** 用户 id */
    private Long userId;

    /** 累计听歌时长（秒） */
    private Long totalSeconds;

    /** 播放次数 */
    private Long playCount;
}
