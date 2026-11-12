package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 抖音热歌榜歌曲实体，对应数据库表 douyin_hot_song
 *
 * 仅存储真实热歌的元数据（歌名/歌手/专辑/时长），用于曲库展示。
 * 音源走合成兜底（/api/stream?id=），不涉及任何受版权保护的真实音频。
 */
@Data
@TableName("douyin_hot_song")
public class DouyinHotSong {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 名次（从 1 开始） */
    private Integer rankNo;

    /** 歌曲名 */
    private String title;

    /** 歌手 / 乐队 */
    private String artist;

    /** 所属专辑 */
    private String album;

    /** 时长（秒） */
    private Integer duration;

    /** 热度值（用于展示排序） */
    private Long hotValue;

    /** 趋势：up 升 / down 降 / flat 持平 / new 新进 */
    private String trend;

    /** 真实音源直链（可选，存在则优先播放） */
    private String url;

    /** 创建时间（数据库默认值填充） */
    private LocalDateTime createTime;

    /** 更新时间（数据库默认值填充） */
    private LocalDateTime updateTime;

    /** 逻辑删除：0-未删 1-已删 */
    @TableLogic
    private Integer deleted;

    /** 关联主曲库 song 表的统一 id（真实列 song_id，收藏/播放用此 id） */
    @TableField("song_id")
    private Long songId;
}
