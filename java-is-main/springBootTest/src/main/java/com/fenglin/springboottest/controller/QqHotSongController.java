package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.QqHotSong;
import com.fenglin.springboottest.service.QqHotSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * QQ音乐热歌榜接口：GET /api/qq/hot
 * 公开接口（不经过 JWT 拦截器），CORS 由 CorsConfig 放行 /api/**。
 */
@RestController
@RequestMapping("/api/qq")
public class QqHotSongController {

    @Autowired
    private QqHotSongService qqHotSongService;

    /** QQ音乐热歌榜（按名次升序） */
    @GetMapping("/hot")
    public Result<List<QqHotSong>> hot() {
        return Result.ok("QQ音乐热歌榜", qqHotSongService.hotSongs());
    }
}
