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
}
