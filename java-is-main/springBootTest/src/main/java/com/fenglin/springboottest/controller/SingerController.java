package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.SingerDetailVO;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.service.SingerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 歌手主页接口：歌手详情与发布过的歌曲。
 * 公开接口（不经过 JWT 拦截器），CORS 由 CorsConfig 放行 /api/**。
 */
@RestController
@RequestMapping("/api/singer")
public class SingerController {

    @Autowired
    private SingerService singerService;

    /** 歌手主页：基础信息 + 发布过的歌曲 + 作品统计 */
    @GetMapping("/{id}")
    public Result<SingerDetailVO> detail(@PathVariable Long id) {
        SingerDetailVO detail = singerService.detail(id);
        if (detail == null) {
            return Result.fail(404, "未找到该歌手");
        }
        return Result.ok("歌手详情", detail);
    }

    /** 该歌手发布过的歌曲（按播放量降序），供单独刷新列表使用 */
    @GetMapping("/{id}/songs")
    public Result<List<Song>> songs(@PathVariable Long id) {
        return Result.ok("歌手歌曲", singerService.songsOf(id));
    }
}
