package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.UserPlaylistSong;
import org.apache.ibatis.annotations.Mapper;

/**
 * 个人歌单歌曲关联 Mapper
 */
@Mapper
public interface UserPlaylistSongMapper extends BaseMapper<UserPlaylistSong> {
}
