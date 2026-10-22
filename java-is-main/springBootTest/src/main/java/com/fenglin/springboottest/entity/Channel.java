package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 热门频道实体，对应数据库表 channel
 */
@Data
@TableName("channel")
public class Channel {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 频道名称 */
    private String name;

    /** 频道图标（emoji） */
    private String icon;

    /** 图标底色渐变编号 p1~p8 */
    private String tone;

    /** 当前在听人数 */
    private Long listeners;

    /** 展示顺序（小在前） */
    private Integer sortOrder;

    /** 创建时间（数据库默认值填充） */
    private LocalDateTime createTime;

    /** 更新时间（数据库默认值填充） */
    private LocalDateTime updateTime;

    /** 逻辑删除：0-未删 1-已删 */
    @TableLogic
    private Integer deleted;
}
