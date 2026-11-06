package com.fenglin.springboottest.service;

import com.fenglin.springboottest.dto.MomentVO;
import com.fenglin.springboottest.dto.ProfileVO;
import com.fenglin.springboottest.dto.RankUserVO;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.entity.User;

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
}
