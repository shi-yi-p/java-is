package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fenglin.springboottest.dto.FeedbackVO;
import com.fenglin.springboottest.entity.Feedback;
import com.fenglin.springboottest.mapper.FeedbackMapper;
import com.fenglin.springboottest.service.FeedbackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 意见反馈服务实现
 */
@Service
public class FeedbackServiceImpl implements FeedbackService {

    @Autowired
    private FeedbackMapper feedbackMapper;

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Override
    @Transactional
    public FeedbackVO submit(Long userId, String type, String content, String contact) {
        Feedback f = new Feedback();
        f.setUserId(userId);
        String t = (type == null || type.trim().isEmpty()) ? "other" : type.trim();
        f.setType(t);
        f.setContent(content.trim());
        f.setContact(contact == null || contact.trim().isEmpty() ? null : contact.trim());
        f.setStatus(0);
        feedbackMapper.insert(f);
        // 回读一次，拿到数据库生成的 create_time（insert 后实体不会自动填充时间字段）
        Feedback saved = feedbackMapper.selectById(f.getId());
        return toVO(saved != null ? saved : f);
    }

    @Override
    public List<FeedbackVO> listMine(Long userId) {
        if (userId == null) {
            return List.of();
        }
        return feedbackMapper.selectList(Wrappers.<Feedback>lambdaQuery()
                        .eq(Feedback::getUserId, userId)
                        .orderByDesc(Feedback::getCreateTime))
                .stream().map(this::toVO).collect(Collectors.toList());
    }

    private FeedbackVO toVO(Feedback f) {
        FeedbackVO vo = new FeedbackVO();
        vo.setId(f.getId());
        vo.setType(f.getType());
        vo.setContent(f.getContent());
        vo.setContact(f.getContact());
        vo.setStatus(f.getStatus() == null ? 0 : f.getStatus());
        vo.setReply(f.getReply());
        vo.setCreateTime(f.getCreateTime() != null ? f.getCreateTime().format(FMT) : "");
        return vo;
    }
}
