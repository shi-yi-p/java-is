package com.fenglin.springboottest.service;

import com.fenglin.springboottest.dto.FeedbackVO;

import java.util.List;

/**
 * 意见反馈服务
 */
public interface FeedbackService {

    /** 提交反馈 */
    FeedbackVO submit(Long userId, String type, String content, String contact);

    /** 查询我的反馈（按提交时间倒序） */
    List<FeedbackVO> listMine(Long userId);
}
