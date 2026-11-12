package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 浏览他人主页（只读）返回的视图对象。
 * 在个人主页 ProfileVO 的基础上，额外携带与当前浏览者的关系：
 * - isFollowing：当前浏览者是否已关注该用户
 * - mutualFollow：该用户是否也关注了浏览者（即好友）
 */
@Data
public class UserProfileVO {

    /** 用户主键 */
    private Long id;

    /** 账号 */
    private String account;

    /** 昵称（兜底为账号） */
    private String nickname;

    /** 头像：URL 或 emoji（空则前端用昵称首字母兜底） */
    private String avatar;

    /** 对外 UID（uid = 10000 + id） */
    private Long uid;

    /** 累计听歌时长（秒） */
    private long listenSeconds;

    /** 播放次数 */
    private long playCount;

    /** 收藏数 */
    private long favoriteCount;

    /** 关注数（我关注了别人） */
    private long following;

    /** 粉丝数（别人关注了我） */
    private long followers;

    /** 鲨鱼等级 */
    private int level;

    /** 等级名称 */
    private String levelName;

    /** 距下一级所需秒数 */
    private long nextLevelSeconds;

    /** 当前等级进度百分比 0~100 */
    private int progress;

    /** 当前浏览者是否已关注该用户 */
    private boolean followed;

    /** 该用户是否也关注了浏览者（互相关注 = 好友） */
    private boolean mutualFollow;
}
