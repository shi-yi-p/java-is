package com.fenglin.springboottest.dto;

import lombok.Data;

/**
 * 意见反馈视图对象（返回给前端展示）
 */
@Data
public class FeedbackVO {

    private Long id;

    /** 反馈类型 */
    private String type;

    /** 反馈内容 */
    private String content;

    /** 联系方式（选填） */
    private String contact;

    /** 处理状态：0-待处理 1-已处理 */
    private Integer status;

    /** 官方回复（选填） */
    private String reply;

    /** 格式化后的提交时间 */
    private String createTime;
}
