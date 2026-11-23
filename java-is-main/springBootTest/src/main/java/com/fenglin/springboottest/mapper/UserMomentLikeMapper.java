package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.UserMomentLike;
import org.apache.ibatis.annotations.Mapper;

/**
 * 动态点赞 Mapper
 */
@Mapper
public interface UserMomentLikeMapper extends BaseMapper<UserMomentLike> {
}
