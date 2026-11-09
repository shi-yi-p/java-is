package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.dto.ListenAgg;
import com.fenglin.springboottest.entity.PlayHistory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface PlayHistoryMapper extends BaseMapper<PlayHistory> {

    /**
     * 汇总某用户累计听歌时长（秒），由数据库 SUM 聚合，避免把全部历史行拉到内存再累加。
     */
    @Select("SELECT COALESCE(SUM(duration), 0) FROM play_history WHERE user_id = #{userId} AND deleted = 0")
    long sumListenSeconds(@Param("userId") Long userId);

    /**
     * 统计所有用户累计听歌时长与播放次数（按 user_id 分组），由数据库 GROUP BY 聚合。
     * 返回列：user_id、total_seconds、play_count，按时长降序。
     */
    @Select("SELECT user_id AS userId, COALESCE(SUM(duration), 0) AS totalSeconds, COUNT(*) AS playCount " +
            "FROM play_history WHERE deleted = 0 " +
            "GROUP BY user_id ORDER BY totalSeconds DESC")
    List<ListenAgg> listenAggregates();
}
