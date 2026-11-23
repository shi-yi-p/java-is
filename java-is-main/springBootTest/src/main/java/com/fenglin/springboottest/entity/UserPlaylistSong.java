package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 个人歌单-歌曲关联实体，对应数据库表 user_playlist_song。
 * 一个歌单可含多首歌，一首歌也可出现在多个歌单；playlist_id + song_id 唯一。
 */
@Data
@TableName("user_playlist_song")
public class UserPlaylistSong {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 所属歌单 id */
    private Long playlistId;

    /** 歌曲 id（关联 song 表） */
    private Long songId;

    /** 歌曲在歌单中的排序 */
    private Integer sortOrder;

    /** 加入时间 */
    private LocalDateTime createTime;
}
