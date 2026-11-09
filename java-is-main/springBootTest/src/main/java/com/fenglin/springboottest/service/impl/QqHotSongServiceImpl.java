package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.common.SongIdResolver;
import com.fenglin.springboottest.entity.QqHotSong;
import com.fenglin.springboottest.mapper.QqHotSongMapper;
import com.fenglin.springboottest.service.QqHotSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * QQ音乐热歌榜服务实现
 */
@Service
public class QqHotSongServiceImpl implements QqHotSongService {

    @Autowired
    private QqHotSongMapper qqHotSongMapper;

    @Autowired
    private SongIdResolver songIdResolver;

    @Override
    public List<QqHotSong> hotSongs() {
        List<QqHotSong> list = qqHotSongMapper.selectList(
                new LambdaQueryWrapper<QqHotSong>()
                        .orderByAsc(QqHotSong::getRankNo));
        songIdResolver.fillSongIds(list, QqHotSong::getTitle, QqHotSong::getArtist, QqHotSong::setSongId);
        return list;
    }
}
