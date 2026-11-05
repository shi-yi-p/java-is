package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.NeteaseHotSong;
import com.fenglin.springboottest.service.NeteaseHotSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 网易云热歌榜接口：GET /api/netease/hot
 * 公开接口（不经过 JWT 拦截器），CORS 由 CorsConfig 放行 /api/**。
 */
@RestController
@RequestMapping("/api/netease")
public class NeteaseHotSongController {

    @Autowired
    private NeteaseHotSongService neteaseHotSongService;

    /** 网易云热歌榜（按名次升序） */
    @GetMapping("/hot")
    public Result<List<NeteaseHotSong>> hot() {
        return Result.ok("网易云热歌榜", neteaseHotSongService.hotSongs());
    }
}
