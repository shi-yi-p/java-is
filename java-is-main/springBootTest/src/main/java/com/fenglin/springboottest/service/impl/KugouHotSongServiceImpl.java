package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.common.SongIdResolver;
import com.fenglin.springboottest.entity.KugouHotSong;
import com.fenglin.springboottest.mapper.KugouHotSongMapper;
import com.fenglin.springboottest.service.KugouHotSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 酷狗热歌榜服务实现
 */
@Service
public class KugouHotSongServiceImpl implements KugouHotSongService {

    @Autowired
    private KugouHotSongMapper kugouHotSongMapper;

    @Autowired
    private SongIdResolver songIdResolver;

    @Override
    public List<KugouHotSong> hotSongs() {
        List<KugouHotSong> list = kugouHotSongMapper.selectList(
                new LambdaQueryWrapper<KugouHotSong>()
                        .orderByAsc(KugouHotSong::getRankNo));
        songIdResolver.fillSongIds(list, KugouHotSong::getTitle, KugouHotSong::getArtist, KugouHotSong::setSongId);
        return list;
    }
}
