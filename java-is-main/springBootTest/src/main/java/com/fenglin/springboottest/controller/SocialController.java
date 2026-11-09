package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.ForumCommentVO;
import com.fenglin.springboottest.dto.ForumPostVO;
import com.fenglin.springboottest.service.SocialService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 社交接口：论坛（分板块帖子/评论）。
 * 路径前缀 /api/social，全部需登录。
 */
@RestController
@RequestMapping("/api/social")
public class SocialController {

    @Autowired
    private SocialService socialService;

    /** 直接从拦截器注入的 userId 读取，避免重复查库（account → id） */
    private Long resolveUserId(HttpServletRequest request) {
        Object uid = request.getAttribute("userId");
        return uid instanceof Long ? (Long) uid : null;
    }

    // ================= 论坛帖子 =================

    @GetMapping("/posts")
    public Result<List<ForumPostVO>> posts(@RequestParam(required = false) String category) {
        return Result.ok("帖子列表", socialService.listPosts(category));
    }

    @GetMapping("/post")
    public Result<ForumPostVO> post(@RequestParam Long postId) {
        ForumPostVO vo = socialService.getPost(postId);
        return vo != null ? Result.ok("帖子详情", vo) : Result.fail(404, "帖子不存在");
    }

    @PostMapping("/post")
    public Result<ForumPostVO> createPost(@RequestBody Map<String, String> body, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        String title = body.get("title");
        String content = body.get("content");
        String category = body.get("category");
        if (title == null || title.trim().isEmpty()) {
            return Result.fail(400, "标题不能为空");
        }
        if (content == null || content.trim().isEmpty()) {
            return Result.fail(400, "内容不能为空");
        }
        return Result.ok("发帖成功", socialService.createPost(uid, title.trim(), content.trim(), category));
    }

    @PostMapping("/post/like")
    public Result<Void> likePost(@RequestParam Long postId) {
        return socialService.likePost(postId) ? Result.ok("点赞成功 ❤️") : Result.fail(404, "帖子不存在");
    }

    // ================= 论坛评论 =================

    @GetMapping("/comments")
    public Result<List<ForumCommentVO>> comments(@RequestParam Long postId) {
        return Result.ok("评论列表", socialService.listComments(postId));
    }

    @PostMapping("/comment")
    public Result<ForumCommentVO> addComment(@RequestBody Map<String, String> body, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        Long postId = null;
        try { postId = Long.valueOf(body.get("postId")); } catch (Exception ignored) {}
        String content = body.get("content");
        if (postId == null) return Result.fail(400, "缺少帖子 id");
        if (content == null || content.trim().isEmpty()) return Result.fail(400, "评论内容不能为空");
        return Result.ok("评论成功", socialService.addComment(uid, postId, content.trim()));
    }
}
