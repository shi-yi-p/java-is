package com.fenglin.springboottest.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 热门歌手实体，对应数据库表 singer
 */
@Data
@TableName("singer")
public class Singer {

    /** 主键，数据库自增 */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 歌手 / 乐队名 */
    private String name;

    /** 地区分类：华语 / 欧美 / 日韩 */
    private String tab;

    /** 粉丝数 */
    private Long fans;

    /** 头像渐变配色编号 p1~p8 */
    private String tone;

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
