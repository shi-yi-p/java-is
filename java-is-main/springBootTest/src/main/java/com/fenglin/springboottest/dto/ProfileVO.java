package com.fenglin.springboottest.dto;

import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.entity.User;
import lombok.Data;

/**
 * 个人主页汇总信息：用户基础信息 + 社交/听歌统计。
 * 用于 GET /api/profile 的返回结构。
 */
@Data
public class ProfileVO {

    /** 用户 id */
    private Long id;

    /** 账户 */
    private String account;

    /** 昵称 */
    private String nickname;

    /** 头像（URL 或 emoji，空则前端用昵称首字母） */
    private String avatar;

    /** UID（对外唯一标识 = 10000 + id） */
    private Long uid;

    /** 关注数（我关注的人） */
    private long following;

    /** 粉丝数（关注我的人） */
    private long followers;

    /** 收藏歌曲数 */
    private long favoriteCount;

    /** 播放历史总次数（即累计播放量） */
    private long playCount;

    /** 创建的歌单数 */
    private long playlistCount;

    /** 累计听歌时长（秒） */
    private long listenSeconds;

    /** 鲨鱼等级（根据听歌时长计算） */
    private int level;

    /** 鲨鱼等级名称 */
    private String levelName;

    /** 距离下一等级还需的听歌秒数 */
    private long nextLevelSeconds;

    /** 当前等级进度百分比（0~100，用于进度条，满级 100） */
    private int progress;
}
