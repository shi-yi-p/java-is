package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.common.SongIdResolver;
import com.fenglin.springboottest.entity.DouyinHotSong;
import com.fenglin.springboottest.mapper.DouyinHotSongMapper;
import com.fenglin.springboottest.service.DouyinHotSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 抖音热歌榜服务实现
 */
@Service
public class DouyinHotSongServiceImpl implements DouyinHotSongService {

    @Autowired
    private DouyinHotSongMapper douyinHotSongMapper;

    @Autowired
    private SongIdResolver songIdResolver;

    @Override
    public List<DouyinHotSong> hotSongs() {
        List<DouyinHotSong> list = douyinHotSongMapper.selectList(
                new LambdaQueryWrapper<DouyinHotSong>()
                        .orderByAsc(DouyinHotSong::getRankNo));
        // 填充主曲库统一 songId，供收藏 / 播放记录引用
        songIdResolver.fillSongIds(list, DouyinHotSong::getTitle, DouyinHotSong::getArtist, DouyinHotSong::setSongId);
        return list;
    }
}
