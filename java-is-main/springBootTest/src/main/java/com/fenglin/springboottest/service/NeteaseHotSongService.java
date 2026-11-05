package com.fenglin.springboottest.service;

import com.fenglin.springboottest.entity.NeteaseHotSong;

import java.util.List;

/**
 * 网易云热歌榜服务
 */
public interface NeteaseHotSongService {

    /** 网易云热歌榜列表（按名次升序） */
    List<NeteaseHotSong> hotSongs();
}
