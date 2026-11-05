package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.KugouHotSong;
import com.fenglin.springboottest.service.KugouHotSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 酷狗热歌榜接口：GET /api/kugou/hot
 * 公开接口（不经过 JWT 拦截器），CORS 由 CorsConfig 放行 /api/**。
 */
@RestController
@RequestMapping("/api/kugou")
public class KugouHotSongController {

    @Autowired
    private KugouHotSongService kugouHotSongService;

    /** 酷狗热歌榜（按名次升序） */
    @GetMapping("/hot")
    public Result<List<KugouHotSong>> hot() {
        return Result.ok("酷狗热歌榜", kugouHotSongService.hotSongs());
    }
}
