package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fenglin.springboottest.dto.ForumCommentVO;
import com.fenglin.springboottest.dto.ForumPostVO;
import com.fenglin.springboottest.entity.ForumComment;
import com.fenglin.springboottest.entity.ForumPost;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.mapper.ForumCommentMapper;
import com.fenglin.springboottest.mapper.ForumPostMapper;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.service.SocialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 社交服务实现：论坛（分板块帖子 / 评论）。
 */
@Service
public class SocialServiceImpl implements SocialService {

    @Autowired
    private ForumPostMapper postMapper;
    @Autowired
    private ForumCommentMapper commentMapper;
    @Autowired
    private UserMapper userMapper;

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    // ================= 论坛帖子 =================

    @Override
    public List<ForumPostVO> listPosts(String category) {
        var qw = Wrappers.<ForumPost>lambdaQuery().orderByDesc(ForumPost::getCreateTime);
        if (category != null && !category.trim().isEmpty()) {
            qw.eq(ForumPost::getCategory, category.trim());
        }
        List<ForumPost> posts = postMapper.selectList(qw);
        // 一次性批量查询所有涉及的用户，避免 N+1
        Map<Long, User> users = loadUsers(posts.stream().map(ForumPost::getUserId).toList());
        return posts.stream().map(p -> toPostVO(p, users)).collect(Collectors.toList());
    }

    @Override
    public ForumPostVO getPost(Long postId) {
        ForumPost post = postMapper.selectById(postId);
        if (post == null) {
            return null;
        }
        // 浏览数 +1
        post.setViews((post.getViews() == null ? 0 : post.getViews()) + 1);
        postMapper.updateById(post);
        return toPostVO(post, loadUsers(java.util.Collections.singletonList(post.getUserId())));
    }

    @Override
    @Transactional
    public ForumPostVO createPost(Long userId, String title, String content, String category) {
        ForumPost post = new ForumPost();
        post.setUserId(userId);
        post.setTitle(title);
        post.setContent(content);
        // 板块：非法值兜底为"闲聊"
        String cat = (category == null || category.trim().isEmpty()) ? "chat" : category.trim();
        post.setCategory(cat);
        post.setLikes(0L);
        post.setComments(0L);
        post.setViews(0L);
        postMapper.insert(post);
        return toPostVO(post, loadUsers(java.util.Collections.singletonList(post.getUserId())));
    }

    @Override
    @Transactional
    public boolean likePost(Long postId) {
        ForumPost post = postMapper.selectById(postId);
        if (post == null) {
            return false;
        }
        post.setLikes((post.getLikes() == null ? 0 : post.getLikes()) + 1);
        return postMapper.updateById(post) > 0;
    }

    // ================= 论坛评论 =================

    @Override
    public List<ForumCommentVO> listComments(Long postId) {
        List<ForumComment> list = commentMapper.selectList(Wrappers.<ForumComment>lambdaQuery()
                .eq(ForumComment::getPostId, postId)
                .orderByAsc(ForumComment::getCreateTime));
        // 一次性批量查询所有涉及的用户，避免 N+1
        Map<Long, User> users = loadUsers(list.stream().map(ForumComment::getUserId).toList());
        return list.stream().map(c -> toCommentVO(c, users)).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public ForumCommentVO addComment(Long userId, Long postId, String content) {
        ForumComment c = new ForumComment();
        c.setPostId(postId);
        c.setUserId(userId);
        c.setContent(content);
        c.setLikes(0L);
        commentMapper.insert(c);

        // 帖子评论数 +1
        ForumPost post = postMapper.selectById(postId);
        if (post != null) {
            post.setComments((post.getComments() == null ? 0 : post.getComments()) + 1);
            postMapper.updateById(post);
        }
        return toCommentVO(c, loadUsers(java.util.Collections.singletonList(c.getUserId())));
    }

    // ================= 私有工具 =================

    /** 批量加载用户，返回 userId → User 映射（一次 IN 查询，消除 N+1） */
    private Map<Long, User> loadUsers(List<Long> userIds) {
        if (userIds == null || userIds.isEmpty()) {
            return java.util.Collections.emptyMap();
        }
        List<Long> distinct = userIds.stream().filter(java.util.Objects::nonNull).distinct().toList();
        if (distinct.isEmpty()) {
            return java.util.Collections.emptyMap();
        }
        return userMapper.selectBatchIds(distinct).stream()
                .collect(Collectors.toMap(User::getId, u -> u, (a, b) -> a));
    }

    private ForumPostVO toPostVO(ForumPost p, Map<Long, User> users) {
        ForumPostVO vo = new ForumPostVO();
        vo.setId(p.getId());
        vo.setUserId(p.getUserId());
        vo.setTitle(p.getTitle());
        vo.setContent(p.getContent());
        vo.setCategory(p.getCategory());
        vo.setLikes(p.getLikes() == null ? 0 : p.getLikes());
        vo.setComments(p.getComments() == null ? 0 : p.getComments());
        vo.setViews(p.getViews() == null ? 0 : p.getViews());
        User u = users.get(p.getUserId());
        if (u != null) {
            String nick = u.getNickname() != null ? u.getNickname() : u.getAccount();
            vo.setNickname(nick);
            vo.setAvatarLetter(nick == null || nick.isEmpty() ? "鲨" : nick.substring(0, 1));
        } else {
            vo.setNickname("未知用户");
            vo.setAvatarLetter("鲨");
        }
        vo.setCreateTime(p.getCreateTime() != null ? p.getCreateTime().format(FMT) : "");
        return vo;
    }

    private ForumCommentVO toCommentVO(ForumComment c, Map<Long, User> users) {
        ForumCommentVO vo = new ForumCommentVO();
        vo.setId(c.getId());
        vo.setPostId(c.getPostId());
        vo.setUserId(c.getUserId());
        vo.setContent(c.getContent());
        vo.setLikes(c.getLikes() == null ? 0 : c.getLikes());
        User u = users.get(c.getUserId());
        if (u != null) {
            String nick = u.getNickname() != null ? u.getNickname() : u.getAccount();
            vo.setNickname(nick);
            vo.setAvatarLetter(nick == null || nick.isEmpty() ? "鲨" : nick.substring(0, 1));
        } else {
            vo.setNickname("未知用户");
            vo.setAvatarLetter("鲨");
        }
        vo.setCreateTime(c.getCreateTime() != null ? c.getCreateTime().format(FMT) : "");
        return vo;
    }
}
