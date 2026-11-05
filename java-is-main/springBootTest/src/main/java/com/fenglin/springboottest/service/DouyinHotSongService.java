package com.fenglin.springboottest.service;

import com.fenglin.springboottest.entity.DouyinHotSong;

import java.util.List;

/**
 * 抖音热歌榜服务
 */
public interface DouyinHotSongService {

    /** 抖音热歌榜列表（按名次升序） */
    List<DouyinHotSong> hotSongs();
}
