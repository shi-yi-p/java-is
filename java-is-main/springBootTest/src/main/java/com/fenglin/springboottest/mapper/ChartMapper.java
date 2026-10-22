package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.Chart;
import org.apache.ibatis.annotations.Mapper;

/**
 * 热门榜单 Mapper，继承 MyBatis-Plus 的 BaseMapper 即可获得 CRUD 能力
 */
@Mapper
public interface ChartMapper extends BaseMapper<Chart> {
}
