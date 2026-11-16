package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.LoginHistory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 登录历史 Mapper，继承 MyBatis-Plus 的 BaseMapper 获得 CRUD 能力。
 */
@Mapper
public interface LoginHistoryMapper extends BaseMapper<LoginHistory> {

    /**
     * 查询历史账户：按账户去重，返回每个账户最近一次登录时间（倒序）。
     * 用于登录页「历史账户」下拉，最多取最近 10 个账户。
     */
    @Select("SELECT MAX(id) AS id, user_id, account, " +
            "       (SELECT nickname FROM login_history lh2 WHERE lh2.account = lh.account ORDER BY id DESC LIMIT 1) AS nickname, " +
            "       (SELECT ip FROM login_history lh3 WHERE lh3.account = lh.account ORDER BY id DESC LIMIT 1) AS ip, " +
            "       MAX(login_time) AS login_time " +
            "FROM login_history lh " +
            "WHERE lh.deleted = 0 " +
            "GROUP BY account, user_id " +
            "ORDER BY MAX(login_time) DESC " +
            "LIMIT 10")
    List<LoginHistory> selectRecentAccounts();
}
