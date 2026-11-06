package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fenglin.springboottest.common.SharkLevel;
import com.fenglin.springboottest.dto.MomentVO;
import com.fenglin.springboottest.dto.ProfileVO;
import com.fenglin.springboottest.dto.RankUserVO;
import com.fenglin.springboottest.entity.PlayHistory;
import com.fenglin.springboottest.entity.Playlist;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.entity.UserFavorite;
import com.fenglin.springboottest.entity.UserFollow;
import com.fenglin.springboottest.entity.UserMoment;
import com.fenglin.springboottest.mapper.PlayHistoryMapper;
import com.fenglin.springboottest.mapper.PlaylistMapper;
import com.fenglin.springboottest.mapper.SongMapper;
import com.fenglin.springboottest.mapper.UserFavoriteMapper;
import com.fenglin.springboottest.mapper.UserFollowMapper;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.mapper.UserMomentMapper;
import com.fenglin.springboottest.service.ProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 个人主页服务实现
 */
@Service
public class ProfileServiceImpl implements ProfileService {

    @Autowired
    private UserMapper userMapper;
    @Autowired
    private SongMapper songMapper;
    @Autowired
    private PlaylistMapper playlistMapper;
    @Autowired
    private UserFollowMapper followMapper;
    @Autowired
    private UserFavoriteMapper favoriteMapper;
    @Autowired
    private PlayHistoryMapper historyMapper;
    @Autowired
    private UserMomentMapper momentMapper;

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    @Override
    public ProfileVO summary(Long userId) {
        ProfileVO vo = new ProfileVO();
        User user = userMapper.selectById(userId);
        if (user == null) {
            return vo;
        }
        vo.setId(user.getId());
        vo.setAccount(user.getAccount());
        vo.setNickname(user.getNickname() != null ? user.getNickname() : user.getAccount());

        vo.setFollowing(followMapper.selectCount(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFollowerId, userId)));
        vo.setFollowers(followMapper.selectCount(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFolloweeId, userId)));
        vo.setFavoriteCount(favoriteMapper.selectCount(Wrappers.<UserFavorite>lambdaQuery()
                .eq(UserFavorite::getUserId, userId)));
        vo.setPlayCount(historyMapper.selectCount(Wrappers.<PlayHistory>lambdaQuery()
                .eq(PlayHistory::getUserId, userId)));
        vo.setPlaylistCount(playlistMapper.selectCount(null));

        // 累计听歌时长（秒） + 鲨鱼等级
        long listenSeconds = sumListenSeconds(userId);
        vo.setListenSeconds(listenSeconds);
        int level = SharkLevel.levelOf(listenSeconds);
        vo.setLevel(level);
        vo.setLevelName(SharkLevel.nameOf(level));
        vo.setNextLevelSeconds(SharkLevel.nextLevelSeconds(listenSeconds));
        return vo;
    }

    /** 汇总某用户累计听歌时长（秒） */
    private long sumListenSeconds(Long userId) {
        List<PlayHistory> list = historyMapper.selectList(Wrappers.<PlayHistory>lambdaQuery()
                .eq(PlayHistory::getUserId, userId)
                .select(PlayHistory::getDuration));
        long sum = 0;
        for (PlayHistory h : list) {
            if (h.getDuration() != null) {
                sum += h.getDuration();
            }
        }
        return sum;
    }

    @Override
    public List<Song> favorites(Long userId) {
        List<UserFavorite> favs = favoriteMapper.selectList(Wrappers.<UserFavorite>lambdaQuery()
                .eq(UserFavorite::getUserId, userId)
                .orderByDesc(UserFavorite::getCreateTime));
        if (favs.isEmpty()) {
            return new ArrayList<>();
        }
        List<Long> songIds = favs.stream().map(UserFavorite::getSongId).collect(Collectors.toList());
        return songMapper.selectBatchIds(songIds);
    }

    @Override
    public List<Song> history(Long userId) {
        // 听歌排行：按播放次数降序取 top
        List<PlayHistory> histories = historyMapper.selectList(Wrappers.<PlayHistory>lambdaQuery()
                .eq(PlayHistory::getUserId, userId)
                .orderByDesc(PlayHistory::getPlayedAt));
        // 按 songId 统计次数并去重（保留最近一次）
        java.util.LinkedHashMap<Long, Integer> counts = new java.util.LinkedHashMap<>();
        for (PlayHistory h : histories) {
            counts.merge(h.getSongId(), 1, Integer::sum);
        }
        // 按次数降序排序
        List<Long> sortedIds = counts.entrySet().stream()
                .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                .map(java.util.Map.Entry::getKey)
                .collect(Collectors.toList());
        if (sortedIds.isEmpty()) {
            return new ArrayList<>();
        }
        List<Song> songs = songMapper.selectBatchIds(sortedIds);
        // 按 sortedIds 顺序重排
        java.util.Map<Long, Song> map = songs.stream()
                .collect(Collectors.toMap(Song::getId, s -> s));
        List<Song> ordered = new ArrayList<>();
        for (Long id : sortedIds) {
            Song s = map.get(id);
            if (s != null) ordered.add(s);
        }
        return ordered;
    }

    @Override
    public List<User> following(Long userId) {
        List<UserFollow> follows = followMapper.selectList(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFollowerId, userId)
                .orderByDesc(UserFollow::getCreateTime));
        if (follows.isEmpty()) {
            return new ArrayList<>();
        }
        List<Long> ids = follows.stream().map(UserFollow::getFolloweeId).collect(Collectors.toList());
        return userMapper.selectBatchIds(ids);
    }

    @Override
    public List<User> followers(Long userId) {
        List<UserFollow> follows = followMapper.selectList(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFolloweeId, userId)
                .orderByDesc(UserFollow::getCreateTime));
        if (follows.isEmpty()) {
            return new ArrayList<>();
        }
        List<Long> ids = follows.stream().map(UserFollow::getFollowerId).collect(Collectors.toList());
        return userMapper.selectBatchIds(ids);
    }

    @Override
    @Transactional
    public boolean favorite(Long userId, Long songId) {
        Long exists = favoriteMapper.selectCount(Wrappers.<UserFavorite>lambdaQuery()
                .eq(UserFavorite::getUserId, userId)
                .eq(UserFavorite::getSongId, songId));
        if (exists > 0) {
            return false;
        }
        UserFavorite f = new UserFavorite();
        f.setUserId(userId);
        f.setSongId(songId);
        favoriteMapper.insert(f);

        // 记录动态
        Song song = songMapper.selectById(songId);
        addMoment(userId, "favorite", "收藏了歌曲「" + (song != null ? song.getTitle() : "") + "」", songId, null);
        return true;
    }

    @Override
    @Transactional
    public boolean unfavorite(Long userId, Long songId) {
        int n = favoriteMapper.delete(Wrappers.<UserFavorite>lambdaQuery()
                .eq(UserFavorite::getUserId, userId)
                .eq(UserFavorite::getSongId, songId));
        return n > 0;
    }

    @Override
    @Transactional
    public boolean follow(Long userId, Long targetId) {
        if (userId.equals(targetId)) {
            return false;
        }
        Long exists = followMapper.selectCount(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFollowerId, userId)
                .eq(UserFollow::getFolloweeId, targetId));
        if (exists > 0) {
            return false;
        }
        UserFollow f = new UserFollow();
        f.setFollowerId(userId);
        f.setFolloweeId(targetId);
        followMapper.insert(f);

        User target = userMapper.selectById(targetId);
        addMoment(userId, "follow", "关注了 " + (target != null ? target.getNickname() : "用户"), null, null);
        return true;
    }

    @Override
    @Transactional
    public boolean unfollow(Long userId, Long targetId) {
        int n = followMapper.delete(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFollowerId, userId)
                .eq(UserFollow::getFolloweeId, targetId));
        return n > 0;
    }

    @Override
    @Transactional
    public void recordPlay(Long userId, Long songId, Integer duration) {
        PlayHistory h = new PlayHistory();
        h.setUserId(userId);
        h.setSongId(songId);
        // 本次收听时长：默认用歌曲真实时长，前端也可上报实际听了几秒
        int seconds = (duration != null && duration > 0) ? duration : 0;
        if (seconds <= 0 && songId != null) {
            Song song = songMapper.selectById(songId);
            if (song != null && song.getDuration() != null && song.getDuration() > 0) {
                seconds = song.getDuration();
            }
        }
        h.setDuration(seconds);
        h.setPlayedAt(LocalDateTime.now());
        historyMapper.insert(h);

        // 记录动态（播放只记录，不刷屏；这里也写一条）
        Song song = songMapper.selectById(songId);
        addMoment(userId, "listen", "正在听「" + (song != null ? song.getTitle() : "") + "」", songId, null);
    }

    @Override
    public List<RankUserVO> listenRanking() {
        // 统计所有用户累计听歌时长（按 user_id 分组求和）
        List<PlayHistory> all = historyMapper.selectList(Wrappers.<PlayHistory>lambdaQuery()
                .select(PlayHistory::getUserId, PlayHistory::getDuration));
        java.util.Map<Long, long[]> agg = new java.util.LinkedHashMap<>(); // userId -> [秒数, 次数]
        for (PlayHistory h : all) {
            long sec = h.getDuration() != null ? h.getDuration() : 0;
            long[] v = agg.computeIfAbsent(h.getUserId(), k -> new long[2]);
            v[0] += sec;
            v[1] += 1;
        }

        // 按时长降序
        List<java.util.Map.Entry<Long, long[]>> sorted = new ArrayList<>(agg.entrySet());
        sorted.sort((a, b) -> Long.compare(b.getValue()[0], a.getValue()[0]));

        List<RankUserVO> result = new ArrayList<>();
        int rank = 1;
        for (java.util.Map.Entry<Long, long[]> e : sorted) {
            User u = userMapper.selectById(e.getKey());
            if (u == null) {
                continue;
            }
            RankUserVO vo = new RankUserVO();
            vo.setRank(rank++);
            vo.setUserId(u.getId());
            vo.setNickname(u.getNickname() != null ? u.getNickname() : u.getAccount());
            String letter = vo.getNickname();
            vo.setAvatarLetter(letter == null || letter.isEmpty() ? "鲨" : letter.substring(0, 1));
            long sec = e.getValue()[0];
            vo.setListenSeconds(sec);
            vo.setPlayCount(e.getValue()[1]);
            int level = SharkLevel.levelOf(sec);
            vo.setLevel(level);
            vo.setLevelName(SharkLevel.nameOf(level));
            result.add(vo);
        }
        return result;
    }

    @Override
    public List<MomentVO> moments(Long userId) {
        List<UserMoment> list = momentMapper.selectList(Wrappers.<UserMoment>lambdaQuery()
                .eq(UserMoment::getUserId, userId)
                .orderByDesc(UserMoment::getCreateTime));
        List<MomentVO> result = new ArrayList<>();
        for (UserMoment m : list) {
            MomentVO vo = new MomentVO();
            vo.setId(m.getId());
            vo.setType(m.getType());
            vo.setContent(m.getContent());
            if (m.getSongId() != null) {
                Song s = songMapper.selectById(m.getSongId());
                vo.setSongTitle(s != null ? s.getTitle() : null);
            }
            if (m.getPlaylistId() != null) {
                Playlist p = playlistMapper.selectById(m.getPlaylistId());
                vo.setPlaylistTitle(p != null ? p.getTitle() : null);
            }
            vo.setCreateTime(m.getCreateTime() != null ? m.getCreateTime().format(FMT) : "");
            result.add(vo);
        }
        return result;
    }

    private void addMoment(Long userId, String type, String content, Long songId, Long playlistId) {
        UserMoment m = new UserMoment();
        m.setUserId(userId);
        m.setType(type);
        m.setContent(content);
        m.setSongId(songId);
        m.setPlaylistId(playlistId);
        momentMapper.insert(m);
    }
}
