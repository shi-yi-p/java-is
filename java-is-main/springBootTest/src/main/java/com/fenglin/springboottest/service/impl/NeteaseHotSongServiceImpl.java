package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
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

    @Override
    public List<NeteaseHotSong> hotSongs() {
        return neteaseHotSongMapper.selectList(
                new LambdaQueryWrapper<NeteaseHotSong>()
                        .orderByAsc(NeteaseHotSong::getRankNo));
    }
}
