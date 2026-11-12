package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
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

    @Override
    public List<KugouHotSong> hotSongs() {
        // song_id 已为真实列，MyBatis-Plus 自动映射到 songId，无需再反查
        return kugouHotSongMapper.selectList(
                new LambdaQueryWrapper<KugouHotSong>()
                        .orderByAsc(KugouHotSong::getRankNo));
    }
}
