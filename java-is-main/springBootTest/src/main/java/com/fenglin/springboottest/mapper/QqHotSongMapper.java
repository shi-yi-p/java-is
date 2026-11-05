package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.QqHotSong;
import org.apache.ibatis.annotations.Mapper;

/**
 * QQ音乐热歌榜 Mapper
 */
@Mapper
public interface QqHotSongMapper extends BaseMapper<QqHotSong> {
}
