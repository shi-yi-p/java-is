package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.ChartVO;
import com.fenglin.springboottest.entity.Audiobook;
import com.fenglin.springboottest.entity.Channel;
import com.fenglin.springboottest.entity.Playlist;
import com.fenglin.springboottest.entity.Singer;
import com.fenglin.springboottest.service.HomeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 首页内容接口：精选歌单 / 热门榜单 / 听书精选 / 热门频道 / 热门歌手。
 * 公开接口（不经过 JWT 拦截器），CORS 由 CorsConfig 放行 /api/**。
 */
@RestController
@RequestMapping("/api/home")
public class HomeController {

    @Autowired
    private HomeService homeService;

    /** 精选歌单 */
    @GetMapping("/playlists")
    public Result<List<Playlist>> playlists() {
        return Result.ok("精选歌单", homeService.playlists());
    }

    /** 热门榜单（含每个榜单的歌曲） */
    @GetMapping("/charts")
    public Result<List<ChartVO>> charts() {
        return Result.ok("热门榜单", homeService.charts());
    }

    /** 听书精选，tab 传 热门/小说/儿童/相声/情感，为空返回全部 */
    @GetMapping("/audiobooks")
    public Result<List<Audiobook>> audiobooks(@RequestParam(required = false) String tab) {
        return Result.ok("听书精选", homeService.audiobooks(tab));
    }

    /** 热门频道 */
    @GetMapping("/channels")
    public Result<List<Channel>> channels() {
        return Result.ok("热门频道", homeService.channels());
    }

    /** 热门歌手，tab 传 华语/欧美/日韩，为空返回全部 */
    @GetMapping("/singers")
    public Result<List<Singer>> singers(@RequestParam(required = false) String tab) {
        return Result.ok("热门歌手", homeService.singers(tab));
    }
}
