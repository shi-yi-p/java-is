package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.service.SearchService;
import com.fenglin.springboottest.service.UserService;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
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

    @Autowired
    private UserService userService;

    @GetMapping("/search")
    public Result<List<Song>> search(@RequestParam(required = false) String keyword) {
        String kw = keyword == null ? "" : keyword.trim();
        if (kw.isEmpty()) {
            return Result.fail(400, "请输入搜索关键词");
        }
        return Result.ok("搜索成功", searchService.search(kw));
    }

    /**
     * 搜索用户：GET /api/search/user?keyword=xxx
     * 优先按 UID 精确匹配（uid = 10000 + id），其次按昵称/账号模糊匹配。
     */
    @GetMapping("/search/user")
    public Result<List<User>> searchUser(@RequestParam(required = false) String keyword) {
        String kw = keyword == null ? "" : keyword.trim();
        if (kw.isEmpty()) {
            return Result.fail(400, "请输入搜索关键词");
        }
        List<User> result = new ArrayList<>();

        // 1) UID 精确匹配（去掉可能的 # 前缀，纯数字则按 uid 反查 id）
        String uidStr = kw.startsWith("#") ? kw.substring(1).trim() : kw;
        if (uidStr.matches("\\d+")) {
            long uid = Long.parseLong(uidStr);
            long id = uid - User.UID_BASE;
            if (id > 0) {
                User byUid = userService.getById(id);
                if (byUid != null) {
                    result.add(byUid);
                }
            }
        }

        // 2) 昵称 / 账号模糊匹配（避免与 UID 命中重复）
        List<User> fuzzy = userService.list(Wrappers.<User>lambdaQuery()
                .and(w -> w.like(User::getNickname, kw).or().like(User::getAccount, kw))
                .last("LIMIT 20"));
        for (User u : fuzzy) {
            boolean dup = result.stream().anyMatch(x -> x.getId().equals(u.getId()));
            if (!dup) {
                result.add(u);
            }
        }

        return Result.ok("搜索用户成功", result);
    }
}
