package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.FeedbackVO;
import com.fenglin.springboottest.service.FeedbackService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

/**
 * 意见反馈接口，路径前缀 /api/feedback，全部需登录。
 */
@RestController
@RequestMapping("/api/feedback")
public class FeedbackController {

    @Autowired
    private FeedbackService feedbackService;

    /** 从 JWT 拦截器注入的 request 属性读取 userId */
    private Long resolveUserId(HttpServletRequest request) {
        Object uid = request.getAttribute("userId");
        return uid instanceof Long ? (Long) uid : null;
    }

    /** 合法的反馈类型白名单 */
    private static final java.util.Set<String> VALID_TYPES =
            java.util.Set.of("bug", "suggestion", "music", "other");

    /** 提交反馈 */
    @PostMapping
    public Result<FeedbackVO> submit(@RequestBody Map<String, String> body, HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        String content = body.get("content");
        if (content == null || content.trim().isEmpty()) {
            return Result.fail(400, "反馈内容不能为空");
        }
        if (content.trim().length() > 2000) {
            return Result.fail(400, "反馈内容最多 2000 字");
        }
        // 类型白名单校验：非法值统一归为 other，避免脏数据入库
        String type = body.get("type");
        if (type != null && !type.trim().isEmpty() && !VALID_TYPES.contains(type.trim())) {
            return Result.fail(400, "反馈类型不合法");
        }
        String contact = body.get("contact");
        if (contact != null && contact.trim().length() > 128) {
            return Result.fail(400, "联系方式最多 128 字");
        }
        return Result.ok("反馈已收到，感谢你的建议！", feedbackService.submit(uid, type, content, contact));
    }

    /** 我的反馈列表 */
    @GetMapping("/mine")
    public Result<List<FeedbackVO>> mine(HttpServletRequest request) {
        Long uid = resolveUserId(request);
        if (uid == null) return Result.fail(401, "未登录");
        return Result.ok("反馈列表", feedbackService.listMine(uid));
    }
}
