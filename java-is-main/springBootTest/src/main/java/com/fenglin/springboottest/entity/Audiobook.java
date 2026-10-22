package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 听书精选实体，对应数据库表 audiobook
 */
@Data
@TableName("audiobook")
public class Audiobook {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 作品标题 */
    private String title;

    /** 主播 / 作者 */
    private String author;

    /** 一句话介绍 */
    private String intro;

    /** 分类：热门 / 小说 / 儿童 / 相声 / 情感 */
    private String tab;

    /** 封面图标（emoji） */
    private String icon;

    /** 封面渐变配色编号 p1~p8 */
    private String tone;

    /** 收听量 */
    private Long listens;

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
