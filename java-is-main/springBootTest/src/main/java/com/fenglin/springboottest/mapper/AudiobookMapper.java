package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.Audiobook;
import org.apache.ibatis.annotations.Mapper;

/**
 * 听书精选 Mapper，继承 MyBatis-Plus 的 BaseMapper 即可获得 CRUD 能力
 */
@Mapper
public interface AudiobookMapper extends BaseMapper<Audiobook> {
}
