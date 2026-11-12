package com.fenglin.springboottest.service;

import com.fenglin.springboottest.dto.MomentVO;
import com.fenglin.springboottest.dto.ProfileVO;
import com.fenglin.springboottest.dto.RankUserVO;
import com.fenglin.springboottest.dto.SongListenStat;
import com.fenglin.springboottest.dto.UserProfileVO;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.entity.UserPlaylist;

import java.util.List;

/**
 * 个人主页服务
 */
public interface ProfileService {

    /**
     * 获取个人主页汇总信息（关注/粉丝/收藏/播放/歌单统计）
     */
    ProfileVO summary(Long userId);

    /**
     * 收藏歌曲列表
     */
    List<Song> favorites(Long userId);

    /**
     * 播放历史（听歌排行，按播放次数降序）
     */
    List<Song> history(Long userId);

    /**
     * 我关注的人
     */
    List<User> following(Long userId);

    /**
     * 我的粉丝
     */
    List<User> followers(Long userId);

    /**
     * 好友列表：互相关注（我关注了对方，对方也关注了我）。
     */
    List<User> friends(Long userId);

    /**
     * 单曲听歌统计：按歌曲聚合的播放次数与累计时长（按时长降序）。
     */
    List<SongListenStat> songListenStats(Long userId);

    /**
     * 更新用户头像（存 URL 或 emoji 标识）。
     *
     * @return 更新后的用户；失败返回 null
     */
    User updateAvatar(Long userId, String avatar);

    /**
     * 更新用户昵称。
     *
     * @return 更新后的用户；昵称为空或失败返回 null
     */
    User updateNickname(Long userId, String nickname);

    /**
     * 收藏歌曲
     *
     * @return true 收藏成功；false 已收藏
     */
    boolean favorite(Long userId, Long songId);

    /**
     * 取消收藏
     *
     * @return true 取消成功；false 原本未收藏
     */
    boolean unfavorite(Long userId, Long songId);

    /**
     * 关注用户
     *
     * @return true 关注成功；false 已关注或关注自己
     */
    boolean follow(Long userId, Long targetId);

    /**
     * 取消关注
     */
    boolean unfollow(Long userId, Long targetId);

    /**
     * 记录一次播放（可带本次收听秒数）
     */
    void recordPlay(Long userId, Long songId, Integer duration);

    /**
     * 动态列表（按时间倒序）
     */
    List<MomentVO> moments(Long userId);

    /**
     * 听歌总排名榜：统计所有用户累计听歌时长，按时长降序。
     */
    List<RankUserVO> listenRanking();

    /**
     * 浏览他人主页（只读）：返回对方资料，并标记浏览者与对方的关系。
     *
     * @param viewerId 当前登录用户 id（浏览者）
     * @param targetId 被浏览用户 id
     * @return 他人主页视图；用户不存在返回 null
     */
    UserProfileVO visitProfile(Long viewerId, Long targetId);

    /**
     * 个人歌单列表（仅当前用户自建歌单，按 user_id 隔离）
     */
    List<UserPlaylist> myPlaylists(Long userId);

    /**
     * 新建个人歌单
     *
     * @return 新建的歌单；歌单名重复返回 null
     */
    UserPlaylist createPlaylist(Long userId, String name, String coverTone);

    /**
     * 重命名个人歌单
     *
     * @return 更新后的歌单；不存在/不属于该用户返回 null
     */
    UserPlaylist renamePlaylist(Long userId, Long playlistId, String name);

    /**
     * 删除个人歌单（逻辑删除，仅能删自己的）
     *
     * @return true 删除成功；false 不存在或不属于该用户
     */
    boolean deletePlaylist(Long userId, Long playlistId);
}
