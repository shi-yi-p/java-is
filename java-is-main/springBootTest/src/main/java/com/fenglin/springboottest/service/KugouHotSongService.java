package com.fenglin.springboottest.service;

import com.fenglin.springboottest.entity.KugouHotSong;

import java.util.List;

/**
 * 酷狗热歌榜服务
 */
public interface KugouHotSongService {

    /** 酷狗热歌榜列表（按名次升序） */
    List<KugouHotSong> hotSongs();
}
