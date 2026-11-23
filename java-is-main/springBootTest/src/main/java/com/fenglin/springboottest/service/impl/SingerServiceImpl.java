package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.dto.SingerDetailVO;
import com.fenglin.springboottest.entity.Singer;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.mapper.SingerMapper;
import com.fenglin.springboottest.mapper.SongMapper;
import com.fenglin.springboottest.service.SingerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 歌手主页服务实现。
 * 说明：song 表与 singer 表无外键关联，作品通过 song.artist == singer.name 字符串精确匹配。
 */
@Service
public class SingerServiceImpl implements SingerService {

    @Autowired
    private SingerMapper singerMapper;

    @Autowired
    private SongMapper songMapper;

    @Override
    public Singer findById(Long id) {
        if (id == null || id <= 0) return null;
        return singerMapper.selectById(id);
    }

    @Override
    public List<Song> songsOf(Long singerId) {
        Singer singer = findById(singerId);
        if (singer == null || singer.getName() == null || singer.getName().trim().isEmpty()) {
            return new ArrayList<>();
        }
        LambdaQueryWrapper<Song> qw = new LambdaQueryWrapper<>();
        qw.eq(Song::getArtist, singer.getName().trim())
          .orderByDesc(Song::getPlays)
          .orderByAsc(Song::getId);
        return songMapper.selectList(qw);
    }

    @Override
    public SingerDetailVO detail(Long id) {
        Singer singer = findById(id);
        if (singer == null) return null;
        return new SingerDetailVO(singer, songsOf(id));
    }
}
