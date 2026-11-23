package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.dto.DailyTopSongVO;
import com.fenglin.springboottest.dto.ListenAgg;
import com.fenglin.springboottest.dto.SongListenStat;
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

    /**
     * 统计某用户按歌曲聚合的听歌次数与累计时长（关联 song 表取歌名/歌手）。
     * 返回列：song_id、title、artist、play_count、total_seconds，按时长降序。
     */
    @Select("SELECT h.song_id AS songId, s.title AS title, s.artist AS artist, " +
            "COUNT(*) AS playCount, COALESCE(SUM(h.duration), 0) AS totalSeconds " +
            "FROM play_history h LEFT JOIN song s ON s.id = h.song_id " +
            "WHERE h.user_id = #{userId} AND h.deleted = 0 " +
            "GROUP BY h.song_id, s.title, s.artist ORDER BY totalSeconds DESC")
    List<SongListenStat> songListenStats(@Param("userId") Long userId);

    /**
     * 统计当日（数据库 CURDATE()）播放次数最多的歌曲，供首页轮播使用。
     * 返回列与 DailyTopSongVO 字段一致，按当日播放次数降序、累计播放量降序。
     */
    @Select("SELECT s.id AS id, s.title AS title, s.artist AS artist, s.album AS album, " +
            "s.duration AS duration, COUNT(*) AS dailyPlays, COALESCE(s.plays, 0) AS totalPlays " +
            "FROM play_history h JOIN song s ON s.id = h.song_id " +
            "WHERE h.deleted = 0 AND s.deleted = 0 AND h.played_at >= CURDATE() " +
            "GROUP BY s.id, s.title, s.artist, s.album, s.duration, s.plays " +
            "ORDER BY dailyPlays DESC, totalPlays DESC LIMIT #{limit}")
    List<DailyTopSongVO> dailyTopSongs(@Param("limit") int limit);
}
