package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.NeteaseHotSong;
import org.apache.ibatis.annotations.Mapper;

/**
 * 网易云热歌榜 Mapper
 */
@Mapper
public interface NeteaseHotSongMapper extends BaseMapper<NeteaseHotSong> {
}
