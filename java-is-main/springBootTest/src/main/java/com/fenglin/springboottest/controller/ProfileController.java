package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.MomentVO;
import com.fenglin.springboottest.dto.ProfileVO;
import com.fenglin.springboottest.dto.RankUserVO;
import com.fenglin.springboottest.dto.SongListenStat;
import com.fenglin.springboottest.dto.UserProfileVO;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.entity.UserPlaylist;
import com.fenglin.springboottest.mapper.SongMapper;
import com.fenglin.springboottest.service.ProfileService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

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
    private SongMapper songMapper;

    /** 直接从拦截器注入的 userId 读取，避免重复查库（account → id） */
    private Long resolveUserId(HttpServletRequest request) {
        Object uid = request.getAttribute("userId");
        return uid instanceof Long ? (Long) uid : null;
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

    /** 好友列表（互相关注） */
    @GetMapping("/friends")
    public Result<List<User>> friends(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("好友", profileService.friends(uid));
    }

    /** 单曲听歌统计（每首歌的次数与累计时长） */
    @GetMapping("/listen-stats")
    public Result<List<SongListenStat>> listenStats(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("听歌统计", profileService.songListenStats(uid));
    }

    /** 更新头像（body: avatar，存 URL 或 emoji；传空字符串可恢复默认） */
    @PostMapping("/avatar")
    public Result<User> updateAvatar(@RequestBody Map<String, String> body, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        User updated = profileService.updateAvatar(uid, body.get("avatar"));
        return updated != null ? Result.ok("头像已更新", updated) : Result.fail(400, "头像不能为空");
    }

    /** 上传本地图片作为头像，保存到 uploads/avatar，返回可访问的 /uploads/... URL */
    @PostMapping(value = "/avatar/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<User> uploadAvatar(@RequestParam("file") MultipartFile file,
                                     HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        if (file == null || file.isEmpty()) return Result.fail(400, "请选择图片文件");
        if (file.getSize() > 2L * 1024 * 1024) return Result.fail(400, "图片不能超过 2MB");

        String original = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
        String ext = "";
        int dot = original.lastIndexOf('.');
        if (dot >= 0) ext = original.substring(dot).toLowerCase(Locale.ROOT);
        if (!ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".png")
                && !ext.equals(".gif") && !ext.equals(".webp") && !ext.equals(".bmp")) {
            return Result.fail(400, "仅支持 jpg / png / gif / webp / bmp 图片");
        }

        try {
            Path dir = Path.of(System.getProperty("user.dir"), "uploads", "avatar");
            Files.createDirectories(dir);
            String name = "u" + uid + "_" + UUID.randomUUID().toString().replace("-", "") + ext;
            Files.copy(file.getInputStream(), dir.resolve(name), StandardCopyOption.REPLACE_EXISTING);
            User updated = profileService.updateAvatar(uid, "/uploads/avatar/" + name);
            return updated != null ? Result.ok("头像已上传", updated) : Result.fail(400, "头像更新失败");
        } catch (IOException e) {
            return Result.fail(500, "图片保存失败：" + e.getMessage());
        }
    }

    /** 更新昵称（body: nickname） */
    @PostMapping("/nickname")
    public Result<User> updateNickname(@RequestBody Map<String, String> body, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        User updated = profileService.updateNickname(uid, body.get("nickname"));
        return updated != null ? Result.ok("昵称已更新", updated) : Result.fail(400, "昵称不能为空");
    }

    /** 动态列表 */
    @GetMapping("/moments")
    public Result<List<MomentVO>> moments(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("动态", profileService.moments(uid));
    }

    /** 自主发布动态（body: content） */
    @PostMapping("/moment")
    public Result<MomentVO> publishMoment(@RequestBody Map<String, String> body,
                                          HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        MomentVO vo = profileService.publishMoment(uid, body.get("content"));
        return vo != null ? Result.ok("发布成功 🎉", vo) : Result.fail(400, "动态内容不能为空");
    }

    /** 删除自己的动态 */
    @DeleteMapping("/moment/{id}")
    public Result<Void> deleteMoment(@PathVariable Long id, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        boolean ok = profileService.deleteMoment(uid, id);
        return ok ? Result.ok("动态已删除") : Result.fail(404, "动态不存在或不属于你");
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

    /** 浏览他人主页（只读）：返回对方资料 + 当前用户与对方的关系 */
    @GetMapping("/visit")
    public Result<UserProfileVO> visit(@RequestParam Long userId, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        if (uid.equals(userId)) return Result.fail(400, "这是你自己的主页，请在「个人主页」查看");
        UserProfileVO vo = profileService.visitProfile(uid, userId);
        return vo != null ? Result.ok("用户主页", vo) : Result.fail(404, "用户不存在");
    }

    /** 浏览他人动态（只读）：返回对方的动态列表，含当前查看者点赞状态 */
    @GetMapping("/visit/moments")
    public Result<List<MomentVO>> visitMoments(@RequestParam Long userId, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("动态", profileService.moments(userId, uid));
    }

    /** 点赞 / 取消点赞动态（切换） */
    @PostMapping("/moment/{id}/like")
    public Result<Boolean> toggleMomentLike(@PathVariable Long id, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        Boolean liked = profileService.toggleMomentLike(uid, id);
        if (liked == null) return Result.fail(404, "动态不存在");
        return Result.ok(liked ? "点赞成功 ❤️" : "已取消点赞", liked);
    }

    /* ============ 个人歌单（按 user_id 隔离） ============ */

    /** 我的歌单列表 */
    @GetMapping("/playlists")
    public Result<List<UserPlaylist>> myPlaylists(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("我的歌单", profileService.myPlaylists(uid));
    }

    /** 新建歌单（body: name, coverTone） */
    @PostMapping("/playlist")
    public Result<UserPlaylist> createPlaylist(@RequestBody Map<String, String> body,
                                                HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        try {
            UserPlaylist p = profileService.createPlaylist(uid, body.get("name"), body.get("coverTone"));
            return p != null ? Result.ok("歌单创建成功 🦈", p)
                    : Result.fail(409, "已存在同名歌单");
        } catch (IllegalArgumentException e) {
            return Result.fail(400, e.getMessage());
        }
    }

    /** 重命名歌单（body: name） */
    @PostMapping("/playlist/{id}/rename")
    public Result<UserPlaylist> renamePlaylist(@PathVariable Long id,
                                                @RequestBody Map<String, String> body,
                                                HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        try {
            UserPlaylist p = profileService.renamePlaylist(uid, id, body.get("name"));
            return p != null ? Result.ok("已重命名", p)
                    : Result.fail(404, "歌单不存在或不属于你");
        } catch (IllegalArgumentException e) {
            return Result.fail(400, e.getMessage());
        }
    }

    /** 删除歌单（逻辑删除，仅能删自己的） */
    @DeleteMapping("/playlist/{id}")
    public Result<Void> deletePlaylist(@PathVariable Long id, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        boolean ok = profileService.deletePlaylist(uid, id);
        return ok ? Result.ok("已删除歌单 🗑️") : Result.fail(404, "歌单不存在或不属于你");
    }

    /* ============ 个人歌单内的歌曲 ============ */

    /** 歌单内的歌曲列表 */
    @GetMapping("/playlist/{id}/songs")
    public Result<List<Song>> playlistSongs(@PathVariable Long id, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        List<Song> songs = profileService.playlistSongs(uid, id);
        return songs != null ? Result.ok("歌单歌曲", songs) : Result.fail(404, "歌单不存在或不属于你");
    }

    /** 往歌单添加歌曲（query: songId） */
    @PostMapping("/playlist/{id}/song")
    public Result<Void> addPlaylistSong(@PathVariable Long id, @RequestParam Long songId,
                                        HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        int r = profileService.addPlaylistSong(uid, id, songId);
        if (r == 1) return Result.ok("已添加到歌单 🎵");
        if (r == -1) return Result.fail(404, "歌单不存在或不属于你");
        return Result.fail(409, "歌曲不存在或已在歌单中");
    }

    /** 从歌单移除歌曲 */
    @DeleteMapping("/playlist/{id}/song/{songId}")
    public Result<Void> removePlaylistSong(@PathVariable Long id, @PathVariable Long songId,
                                           HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        boolean ok = profileService.removePlaylistSong(uid, id, songId);
        return ok ? Result.ok("已从歌单移除") : Result.fail(404, "歌单不存在或不属于你");
    }

    /**
     * 可添加的曲库歌曲（供歌单详情页选择）。支持 keyword 模糊搜索，最多返回 60 首。
     */
    @GetMapping("/library/songs")
    public Result<List<Song>> librarySongs(@RequestParam(required = false) String keyword,
                                           HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Song> q =
                Wrappers.<Song>lambdaQuery();
        if (keyword != null && !keyword.trim().isEmpty()) {
            String kw = keyword.trim();
            q.and(w -> w.like(Song::getTitle, kw).or().like(Song::getArtist, kw));
        }
        q.orderByAsc(Song::getId).last("LIMIT 60");
        return Result.ok("曲库歌曲", songMapper.selectList(q));
    }
}
