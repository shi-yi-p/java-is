package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.UserPlaylist;
import org.apache.ibatis.annotations.Mapper;

/**
 * 个人歌单 Mapper
 */
@Mapper
public interface UserPlaylistMapper extends BaseMapper<UserPlaylist> {
}
