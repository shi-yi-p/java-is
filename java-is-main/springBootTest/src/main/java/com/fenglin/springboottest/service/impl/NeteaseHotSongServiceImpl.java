package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.common.SongIdResolver;
import com.fenglin.springboottest.entity.NeteaseHotSong;
import com.fenglin.springboottest.mapper.NeteaseHotSongMapper;
import com.fenglin.springboottest.service.NeteaseHotSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 网易云热歌榜服务实现
 */
@Service
public class NeteaseHotSongServiceImpl implements NeteaseHotSongService {

    @Autowired
    private NeteaseHotSongMapper neteaseHotSongMapper;

    @Autowired
    private SongIdResolver songIdResolver;

    @Override
    public List<NeteaseHotSong> hotSongs() {
        List<NeteaseHotSong> list = neteaseHotSongMapper.selectList(
                new LambdaQueryWrapper<NeteaseHotSong>()
                        .orderByAsc(NeteaseHotSong::getRankNo));
        songIdResolver.fillSongIds(list, NeteaseHotSong::getTitle, NeteaseHotSong::getArtist, NeteaseHotSong::setSongId);
        return list;
    }
}
