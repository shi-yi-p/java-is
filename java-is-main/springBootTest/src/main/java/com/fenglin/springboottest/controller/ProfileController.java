package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.MomentVO;
import com.fenglin.springboottest.dto.ProfileVO;
import com.fenglin.springboottest.dto.RankUserVO;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.service.ProfileService;
import com.fenglin.springboottest.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 个人主页接口。所有接口都需登录（由 JwtInterceptor 校验并注入 account）。
 * 路径前缀 /api/profile。
 */
@RestController
@RequestMapping("/api/profile")
public class ProfileController {

    @Autowired
    private ProfileService profileService;

    @Autowired
    private UserService userService;

    /** 从拦截器注入的 account 反查用户 id */
    private Long resolveUserId(HttpServletRequest request) {
        String account = (String) request.getAttribute("account");
        if (account == null) {
            return null;
        }
        User user = userService.lambdaQuery().eq(User::getAccount, account).one();
        return user != null ? user.getId() : null;
    }

    /** 个人主页汇总 */
    @GetMapping
    public Result<ProfileVO> summary(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) {
            return Result.fail(401, "未登录");
        }
        return Result.ok("个人主页", profileService.summary(uid));
    }

    /** 收藏歌曲列表 */
    @GetMapping("/favorites")
    public Result<List<Song>> favorites(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("收藏歌曲", profileService.favorites(uid));
    }

    /** 听歌排行（播放历史） */
    @GetMapping("/history")
    public Result<List<Song>> history(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("听歌排行", profileService.history(uid));
    }

    /** 我关注的人 */
    @GetMapping("/following")
    public Result<List<User>> following(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("关注", profileService.following(uid));
    }

    /** 我的粉丝 */
    @GetMapping("/followers")
    public Result<List<User>> followers(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("粉丝", profileService.followers(uid));
    }

    /** 动态列表 */
    @GetMapping("/moments")
    public Result<List<MomentVO>> moments(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("动态", profileService.moments(uid));
    }

    /** 收藏歌曲 */
    @PostMapping("/favorite")
    public Result<Void> favorite(@RequestParam Long songId, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        boolean ok = profileService.favorite(uid, songId);
        return ok ? Result.ok("已收藏 ❤️") : Result.fail(409, "已收藏过该歌曲");
    }

    /** 取消收藏 */
    @PostMapping("/unfavorite")
    public Result<Void> unfavorite(@RequestParam Long songId, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        boolean ok = profileService.unfavorite(uid, songId);
        return ok ? Result.ok("已取消收藏") : Result.fail(409, "原本未收藏");
    }

    /** 关注用户 */
    @PostMapping("/follow")
    public Result<Void> follow(@RequestParam Long targetId, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        boolean ok = profileService.follow(uid, targetId);
        return ok ? Result.ok("已关注 ✅") : Result.fail(409, "已关注或不能关注自己");
    }

    /** 取消关注 */
    @PostMapping("/unfollow")
    public Result<Void> unfollow(@RequestParam Long targetId, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        boolean ok = profileService.unfollow(uid, targetId);
        return ok ? Result.ok("已取消关注") : Result.fail(409, "原本未关注");
    }

    /** 记录播放（播放器播放歌曲时调用，可带本次收听秒数） */
    @PostMapping("/play")
    public Result<Void> play(@RequestParam Long songId,
                             @RequestParam(required = false) Integer duration,
                             HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        profileService.recordPlay(uid, songId, duration);
        return Result.ok("已记录播放");
    }

    /** 听歌总排名榜（统计所有用户累计听歌时长） */
    @GetMapping("/ranking")
    public Result<List<RankUserVO>> ranking(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("听歌总排名", profileService.listenRanking());
    }
}
