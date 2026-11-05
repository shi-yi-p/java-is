package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.KugouHotSong;
import org.apache.ibatis.annotations.Mapper;

/**
 * 酷狗热歌榜 Mapper，继承 MyBatis-Plus 的 BaseMapper 即可获得 CRUD 能力
 */
@Mapper
public interface KugouHotSongMapper extends BaseMapper<KugouHotSong> {
}
