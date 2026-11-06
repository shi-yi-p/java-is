package com.fenglin.springboottest.dto;

import com.fenglin.springboottest.entity.UserMoment;
import lombok.Data;

/**
 * 动态视图对象：动态基础信息 + 关联的歌曲/歌单标题，便于前端直接展示。
 */
@Data
public class MomentVO {

    /** 动态 id */
    private Long id;

    /** 动态类型：listen / favorite / create_playlist / follow */
    private String type;

    /** 动态文本 */
    private String content;

    /** 关联歌曲标题（若有） */
    private String songTitle;

    /** 关联歌单标题（若有） */
    private String playlistTitle;

    /** 发布时间 */
    private String createTime;
}
