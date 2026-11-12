package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 单曲听歌统计：某用户对某首歌的累计播放次数与累计收听时长。
 * 用于个人主页「听歌统计」展示每首歌的时长与次数。
 */
@Data
public class SongListenStat {

    /** 歌曲 id（关联 song 主曲库） */
    private Long songId;

    /** 歌曲名 */
    private String title;

    /** 歌手 */
    private String artist;

    /** 累计播放次数 */
    private Long playCount;

    /** 累计收听时长（秒） */
    private Long totalSeconds;
}
