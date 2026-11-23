package com.fenglin.springboottest.service;

import com.fenglin.springboottest.dto.SingerDetailVO;
import com.fenglin.springboottest.entity.Singer;
import com.fenglin.springboottest.entity.Song;

import java.util.List;

/**
 * 歌手主页服务：歌手详情与作品查询。
 */
public interface SingerService {

    /** 按 id 查询歌手，不存在返回 null */
    Singer findById(Long id);

    /** 查询某歌手发布过的歌曲（singer.name = song.artist，按播放量降序） */
    List<Song> songsOf(Long singerId);

    /** 组装歌手主页数据（基础信息 + 作品 + 统计），不存在返回 null */
    SingerDetailVO detail(Long id);
}
