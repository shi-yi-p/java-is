package com.fenglin.springboottest.service;

import com.fenglin.springboottest.entity.QqHotSong;

import java.util.List;

/**
 * QQ音乐热歌榜服务
 */
public interface QqHotSongService {

    /** QQ音乐热歌榜列表（按名次升序） */
    List<QqHotSong> hotSongs();
}
