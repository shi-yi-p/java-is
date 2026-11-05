package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.DouyinHotSong;
import com.fenglin.springboottest.service.DouyinHotSongService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 抖音热歌榜接口：GET /api/douyin/hot
 * 公开接口（不经过 JWT 拦截器），CORS 由 CorsConfig 放行 /api/**。
 */
@RestController
@RequestMapping("/api/douyin")
public class DouyinHotSongController {

    @Autowired
    private DouyinHotSongService douyinHotSongService;

    /** 抖音热歌榜（按名次升序） */
    @GetMapping("/hot")
    public Result<List<DouyinHotSong>> hot() {
        return Result.ok("抖音热歌榜", douyinHotSongService.hotSongs());
    }
}
