package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 意见反馈实体，对应数据库表 feedback
 */
@Data
@TableName("feedback")
public class Feedback {

    @TableId(type = IdType.AUTO)
    private Long id;

    /** 提交用户 id */
    private Long userId;

    /** 反馈类型：bug / suggestion / music / other */
    private String type;

    /** 反馈内容 */
    private String content;

    /** 联系方式（选填） */
    private String contact;

    /** 处理状态：0-待处理 1-已处理 */
    private Integer status;

    /** 官方回复（选填） */
    private String reply;

    private LocalDateTime createTime;

    /** 逻辑删除 */
    @TableLogic
    private Integer deleted;
}
