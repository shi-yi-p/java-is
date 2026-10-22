package com.fenglin.springboottest.service;

import com.fenglin.springboottest.dto.ChartVO;
import com.fenglin.springboottest.entity.Audiobook;
import com.fenglin.springboottest.entity.Channel;
import com.fenglin.springboottest.entity.Playlist;
import com.fenglin.springboottest.entity.Singer;

import java.util.List;

/**
 * 首页内容服务：精选歌单 + 热门榜单 + 听书精选 + 热门频道 + 热门歌手
 */
public interface HomeService {

    /** 精选歌单列表（按展示顺序） */
    List<Playlist> playlists();

    /** 热门榜单列表（含每个榜单的歌曲，按名次升序） */
    List<ChartVO> charts();

    /** 听书精选列表，tab 为空时返回全部，否则按分类过滤 */
    List<Audiobook> audiobooks(String tab);

    /** 热门频道列表（按展示顺序） */
    List<Channel> channels();

    /** 热门歌手列表，tab 为空时返回全部，否则按地区分类过滤 */
    List<Singer> singers(String tab);
}
