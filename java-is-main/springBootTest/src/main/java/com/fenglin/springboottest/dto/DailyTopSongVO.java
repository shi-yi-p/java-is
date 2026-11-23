package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 首页「每日热播」歌曲视图对象：按当日播放次数排序的 TOP5。
 */
@Data
public class DailyTopSongVO {

    /** 歌曲 id（主曲库 song.id，可直接用于播放） */
    private Long id;

    private String title;

    private String artist;

    private String album;

    /** 时长（秒） */
    private Integer duration;

    /** 今日播放次数 */
    private Long dailyPlays;

    /** 累计播放量（用于不足 5 首时兜底排序） */
    private Long totalPlays;
}
