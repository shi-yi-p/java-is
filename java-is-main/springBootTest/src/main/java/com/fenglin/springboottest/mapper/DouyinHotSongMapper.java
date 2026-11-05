package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.DouyinHotSong;
import org.apache.ibatis.annotations.Mapper;

/**
 * 抖音热歌榜 Mapper，继承 MyBatis-Plus 的 BaseMapper 即可获得 CRUD 能力
 */
@Mapper
public interface DouyinHotSongMapper extends BaseMapper<DouyinHotSong> {
}
