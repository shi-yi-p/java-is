package com.fenglin.springboottest.dto;

import com.fenglin.springboottest.entity.Singer;
import com.fenglin.springboottest.entity.Song;
import lombok.Data;

import java.util.List;

/**
 * 歌手主页视图对象：歌手基础信息 + 发布过的歌曲 + 作品统计。
 * 用于 GET /api/singer/{id} 的返回结构。
 */
@Data
public class SingerDetailVO {

    /** 歌手 id */
    private Long id;

    /** 歌手 / 乐队名 */
    private String name;

    /** 地区分类：华语 / 欧美 / 日韩 */
    private String tab;

    /** 粉丝数 */
    private Long fans;

    /** 头像渐变配色编号 p1~p8 */
    private String tone;

    /** 发布过的歌曲（按播放量降序） */
    private List<Song> songs;

    /** 作品数量 */
    private int songCount;

    /** 作品累计播放量 */
    private long totalPlays;

    public SingerDetailVO() {
    }

    /** 由歌手实体与作品列表构建，统计字段自动计算 */
    public SingerDetailVO(Singer singer, List<Song> songs) {
        this.id = singer.getId();
        this.name = singer.getName();
        this.tab = singer.getTab();
        this.fans = singer.getFans();
        this.tone = singer.getTone();
        this.songs = songs;
        this.songCount = songs == null ? 0 : songs.size();
        long sum = 0;
        if (songs != null) {
            for (Song s : songs) {
                if (s != null && s.getPlays() != null) sum += s.getPlays();
            }
        }
        this.totalPlays = sum;
    }
}
