package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 曲库搜索接口：GET /api/search?keyword=xxx
 * 公开接口（不经过 JWT 拦截器），供首页顶部搜索栏调用。
 */
@RestController
@RequestMapping("/api")
public class SearchController {

    @Autowired
    private SearchService searchService;

    @GetMapping("/search")
    public Result<List<Song>> search(@RequestParam(required = false) String keyword) {
        String kw = keyword == null ? "" : keyword.trim();
        if (kw.isEmpty()) {
            return Result.fail(400, "请输入搜索关键词");
        }
        return Result.ok("搜索成功", searchService.search(kw));
    }
}
