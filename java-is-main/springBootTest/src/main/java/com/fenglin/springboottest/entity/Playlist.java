package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 精选歌单实体，对应数据库表 playlist
 */
@Data
@TableName("playlist")
public class Playlist {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 歌单标题 */
    private String title;

    /** 副标题 / 一句话介绍 */
    private String subtitle;

    /** 分类标签 */
    private String tag;

    /** 封面装饰图标（emoji） */
    private String icon;

    /** 封面渐变配色编号 p1~p8 */
    private String tone;

    /** 播放量 */
    private Long plays;

    /** 展示顺序（小在前） */
    private Integer sortOrder;

    /** 创建时间（数据库默认值填充） */
    private LocalDateTime createTime;

    /** 更新时间（数据库默认值填充） */
    private LocalDateTime updateTime;

    /** 逻辑删除：0-未删 1-已删 */
    @TableLogic
    private Integer deleted;
}
