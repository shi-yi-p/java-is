package com.fenglin.springboottest.service;

import com.fenglin.springboottest.dto.ForumCommentVO;
import com.fenglin.springboottest.dto.ForumPostVO;

import java.util.List;

/**
 * 社交服务：论坛（分板块帖子 / 评论）。
 */
public interface SocialService {

    // ================= 论坛帖子 =================

    /** 帖子列表（按时间倒序；category 为空则返回全部） */
    List<ForumPostVO> listPosts(String category);

    /** 帖子详情（含评论） */
    ForumPostVO getPost(Long postId);

    /** 发帖（category 指定板块） */
    ForumPostVO createPost(Long userId, String title, String content, String category);

    /** 点赞帖子 */
    boolean likePost(Long postId);

    // ================= 论坛评论 =================

    /** 帖子评论列表 */
    List<ForumCommentVO> listComments(Long postId);

    /** 发表评论 */
    ForumCommentVO addComment(Long userId, Long postId, String content);
}
