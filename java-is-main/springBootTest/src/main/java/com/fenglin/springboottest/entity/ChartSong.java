package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

/**
 * 榜单歌曲实体，对应数据库表 chart_song
 */
@Data
@TableName("chart_song")
public class ChartSong {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 所属榜单 id */
    private Long chartId;

    /** 名次（从 1 开始） */
    private Integer rankNo;

    /** 歌曲名 */
    private String title;

    /** 歌手 / 乐队 */
    private String artist;

    /** 趋势：up 升 / down 降 / flat 持平 / new 新进 */
    private String trend;

    /** 逻辑删除：0-未删 1-已删 */
    @TableLogic
    private Integer deleted;
}
