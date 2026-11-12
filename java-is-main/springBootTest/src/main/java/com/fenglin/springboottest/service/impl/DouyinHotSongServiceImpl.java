package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
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

    @Override
    public List<DouyinHotSong> hotSongs() {
        // song_id 已为真实列，MyBatis-Plus 自动映射到 songId，无需再反查
        return douyinHotSongMapper.selectList(
                new LambdaQueryWrapper<DouyinHotSong>()
                        .orderByAsc(DouyinHotSong::getRankNo));
    }
}
