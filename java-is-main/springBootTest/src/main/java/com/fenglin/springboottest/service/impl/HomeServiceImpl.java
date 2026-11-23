package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.dto.ChartVO;
import com.fenglin.springboottest.dto.DailyTopSongVO;
import com.fenglin.springboottest.entity.Audiobook;
import com.fenglin.springboottest.entity.Chart;
import com.fenglin.springboottest.entity.ChartSong;
import com.fenglin.springboottest.entity.Channel;
import com.fenglin.springboottest.entity.Playlist;
import com.fenglin.springboottest.entity.Singer;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.mapper.AudiobookMapper;
import com.fenglin.springboottest.mapper.ChartMapper;
import com.fenglin.springboottest.mapper.ChartSongMapper;
import com.fenglin.springboottest.mapper.ChannelMapper;
import com.fenglin.springboottest.mapper.PlayHistoryMapper;
import com.fenglin.springboottest.mapper.PlaylistMapper;
import com.fenglin.springboottest.mapper.SingerMapper;
import com.fenglin.springboottest.mapper.SongMapper;
import com.fenglin.springboottest.service.HomeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 首页内容服务实现
 */
@Service
public class HomeServiceImpl implements HomeService {

    @Autowired
    private PlaylistMapper playlistMapper;

    @Autowired
    private ChartMapper chartMapper;

    @Autowired
    private ChartSongMapper chartSongMapper;

    @Autowired
    private AudiobookMapper audiobookMapper;

    @Autowired
    private ChannelMapper channelMapper;

    @Autowired
    private SingerMapper singerMapper;

    @Autowired
    private PlayHistoryMapper playHistoryMapper;

    @Autowired
    private SongMapper songMapper;

    @Override
    public List<Playlist> playlists() {
        // 逻辑删除字段由 MyBatis-Plus 自动过滤（deleted = 0）
        return playlistMapper.selectList(
                new LambdaQueryWrapper<Playlist>()
                        .orderByAsc(Playlist::getSortOrder));
    }

    @Override
    public List<ChartVO> charts() {
        List<Chart> list = chartMapper.selectList(
                new LambdaQueryWrapper<Chart>()
                        .orderByAsc(Chart::getSortOrder));
        return list.stream()
                .map(c -> new ChartVO(c, songsOf(c.getId())))
                .toList();
    }

    @Override
    public List<Audiobook> audiobooks(String tab) {
        return audiobookMapper.selectList(
                new LambdaQueryWrapper<Audiobook>()
                        .eq(hasText(tab), Audiobook::getTab, tab)
                        .orderByAsc(Audiobook::getSortOrder));
    }

    @Override
    public List<Channel> channels() {
        return channelMapper.selectList(
                new LambdaQueryWrapper<Channel>()
                        .orderByAsc(Channel::getSortOrder));
    }

    @Override
    public List<Singer> singers(String tab) {
        return singerMapper.selectList(
                new LambdaQueryWrapper<Singer>()
                        .eq(hasText(tab), Singer::getTab, tab)
                        .orderByAsc(Singer::getSortOrder));
    }

    @Override
    public List<DailyTopSongVO> dailyTopSongs() {
        List<DailyTopSongVO> list = playHistoryMapper.dailyTopSongs(5);
        List<DailyTopSongVO> result = list == null ? new ArrayList<>() : new ArrayList<>(list);
        // 当日播放记录不足 5 首时，用累计播放量最高的歌曲补齐，保证轮播始终有 5 首
        if (result.size() < 5) {
            Set<Long> exists = new HashSet<>();
            result.forEach(s -> exists.add(s.getId()));
            List<Song> fallback = songMapper.selectList(
                    new LambdaQueryWrapper<Song>().orderByDesc(Song::getPlays));
            for (Song s : fallback) {
                if (result.size() >= 5) break;
                if (exists.contains(s.getId())) continue;
                DailyTopSongVO vo = new DailyTopSongVO();
                vo.setId(s.getId());
                vo.setTitle(s.getTitle());
                vo.setArtist(s.getArtist());
                vo.setAlbum(s.getAlbum());
                vo.setDuration(s.getDuration());
                vo.setDailyPlays(0L);
                vo.setTotalPlays(s.getPlays() == null ? 0L : s.getPlays());
                result.add(vo);
            }
        }
        return result;
    }

    /** 查询某个榜单下的歌曲，按名次升序 */
    private List<ChartSong> songsOf(Long chartId) {
        return chartSongMapper.selectList(
                new LambdaQueryWrapper<ChartSong>()
                        .eq(ChartSong::getChartId, chartId)
                        .orderByAsc(ChartSong::getRankNo));
    }

    /** 参数非空白才参与查询（否则返回全部分类） */
    private boolean hasText(String s) {
        return s != null && !s.isBlank();
    }
}
