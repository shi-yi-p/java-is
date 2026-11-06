package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.UserMoment;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMomentMapper extends BaseMapper<UserMoment> {
}
