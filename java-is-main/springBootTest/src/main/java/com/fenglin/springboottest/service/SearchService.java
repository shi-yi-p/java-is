package com.fenglin.springboottest.service;

import com.fenglin.springboottest.entity.Song;

import java.util.List;

/**
 * 曲库搜索服务
 */
public interface SearchService {

    /**
     * 按关键词模糊搜索曲库（匹配 歌曲名 / 歌手 / 专辑），
     * 按播放量从高到低返回，最多 20 条。
     */
    List<Song> search(String keyword);
}
