package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.mapper.SongMapper;
import com.fenglin.springboottest.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 曲库搜索服务实现
 */
@Service
public class SearchServiceImpl implements SearchService {

    /** 单次搜索最多返回条数 */
    private static final int LIMIT = 20;

    @Autowired
    private SongMapper songMapper;

    @Override
    public List<Song> search(String keyword) {
        return songMapper.selectList(
                new LambdaQueryWrapper<Song>()
                        // 关键词同时模糊匹配：歌曲名 / 歌手 / 专辑
                        .and(w -> w.like(Song::getTitle, keyword)
                                .or().like(Song::getArtist, keyword)
                                .or().like(Song::getAlbum, keyword))
                        // 播放量高的排前面
                        .orderByDesc(Song::getPlays)
                        .last("LIMIT " + LIMIT));
    }
}
