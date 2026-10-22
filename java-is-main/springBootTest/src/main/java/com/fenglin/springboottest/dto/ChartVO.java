package com.fenglin.springboottest.dto;

import com.fenglin.springboottest.entity.Chart;
import com.fenglin.springboottest.entity.ChartSong;
import lombok.Data;

import java.util.List;

/**
 * 榜单视图对象：榜单基础信息 + 该榜单的歌曲列表，
 * 用于 GET /api/home/charts 的返回结构。
 */
@Data
public class ChartVO {

    /** 榜单 id */
    private Long id;

    /** 榜单名称 */
    private String name;

    /** 榜单头配色：orange / blue / purple / teal */
    private String tone;

    /** 榜单歌曲（按名次升序） */
    private List<ChartSong> songs;

    public ChartVO() {
    }

    /** 由榜单实体构建，歌曲列表由 Service 层填充 */
    public ChartVO(Chart chart, List<ChartSong> songs) {
        this.id = chart.getId();
        this.name = chart.getName();
        this.tone = chart.getTone();
        this.songs = songs;
    }
}
