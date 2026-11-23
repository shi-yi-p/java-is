package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.fenglin.springboottest.common.SharkLevel;
import com.fenglin.springboottest.dto.MomentVO;
import com.fenglin.springboottest.dto.ProfileVO;
import com.fenglin.springboottest.dto.RankUserVO;
import com.fenglin.springboottest.dto.SongListenStat;
import com.fenglin.springboottest.dto.UserProfileVO;
import com.fenglin.springboottest.entity.PlayHistory;
import com.fenglin.springboottest.entity.Playlist;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.entity.UserFavorite;
import com.fenglin.springboottest.entity.UserFollow;
import com.fenglin.springboottest.entity.UserMoment;
import com.fenglin.springboottest.entity.UserMomentLike;
import com.fenglin.springboottest.entity.UserPlaylist;
import com.fenglin.springboottest.entity.UserPlaylistSong;
import com.fenglin.springboottest.mapper.PlayHistoryMapper;
import com.fenglin.springboottest.mapper.PlaylistMapper;
import com.fenglin.springboottest.mapper.SongMapper;
import com.fenglin.springboottest.mapper.UserFavoriteMapper;
import com.fenglin.springboottest.mapper.UserFollowMapper;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.mapper.UserMomentMapper;
import com.fenglin.springboottest.mapper.UserMomentLikeMapper;
import com.fenglin.springboottest.mapper.UserPlaylistMapper;
import com.fenglin.springboottest.mapper.UserPlaylistSongMapper;
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
    @Autowired
    private UserMomentLikeMapper momentLikeMapper;
    @Autowired
    private UserPlaylistMapper userPlaylistMapper;
    @Autowired
    private UserPlaylistSongMapper playlistSongMapper;

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
        vo.setAvatar(user.getAvatar());
        vo.setUid(user.getUid());

        vo.setFollowing(followMapper.selectCount(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFollowerId, userId)));
        vo.setFollowers(followMapper.selectCount(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFolloweeId, userId)));
        vo.setFavoriteCount(favoriteMapper.selectCount(Wrappers.<UserFavorite>lambdaQuery()
                .eq(UserFavorite::getUserId, userId)));
        vo.setPlayCount(historyMapper.selectCount(Wrappers.<PlayHistory>lambdaQuery()
                .eq(PlayHistory::getUserId, userId)));
        // 歌单数：统计当前用户自建的个人歌单，而非全站精选歌单
        vo.setPlaylistCount(userPlaylistMapper.selectCount(Wrappers.<UserPlaylist>lambdaQuery()
                .eq(UserPlaylist::getUserId, userId)));

        // 累计听歌时长（秒） + 鲨鱼等级
        long listenSeconds = sumListenSeconds(userId);
        vo.setListenSeconds(listenSeconds);
        int level = SharkLevel.levelOf(listenSeconds);
        vo.setLevel(level);
        vo.setLevelName(SharkLevel.nameOf(level));
        vo.setNextLevelSeconds(SharkLevel.nextLevelSeconds(listenSeconds));
        vo.setProgress(SharkLevel.progressOf(listenSeconds));
        return vo;
    }

    /** 汇总某用户累计听歌时长（秒）：数据库 SUM 聚合，避免全表拉取 */
    private long sumListenSeconds(Long userId) {
        return historyMapper.sumListenSeconds(userId);
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
    public List<User> friends(Long userId) {
        // 好友 = 互相关注：我关注的人里，对方也关注了我
        List<UserFollow> iFollow = followMapper.selectList(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFollowerId, userId));
        if (iFollow.isEmpty()) {
            return new ArrayList<>();
        }
        List<Long> iFollowIds = iFollow.stream().map(UserFollow::getFolloweeId).collect(Collectors.toList());
        // 这些人里，谁回关了我（follower_id 是对方，followee_id 是我）
        List<UserFollow> backFollow = followMapper.selectList(Wrappers.<UserFollow>lambdaQuery()
                .in(UserFollow::getFollowerId, iFollowIds)
                .eq(UserFollow::getFolloweeId, userId));
        if (backFollow.isEmpty()) {
            return new ArrayList<>();
        }
        List<Long> friendIds = backFollow.stream().map(UserFollow::getFollowerId).collect(Collectors.toList());
        return userMapper.selectBatchIds(friendIds);
    }

    @Override
    public List<SongListenStat> songListenStats(Long userId) {
        List<SongListenStat> stats = historyMapper.songListenStats(userId);
        return stats != null ? stats : new ArrayList<>();
    }

    @Override
    public User updateAvatar(Long userId, String avatar) {
        // null 表示参数缺失；空字符串表示用户主动恢复默认头像
        if (avatar == null) {
            return null;
        }
        User user = userMapper.selectById(userId);
        if (user == null) {
            return null;
        }
        user.setAvatar(avatar.trim());
        userMapper.updateById(user);
        return user;
    }

    @Override
    public User updateNickname(Long userId, String nickname) {
        if (nickname == null || nickname.isBlank()) {
            return null;
        }
        User user = userMapper.selectById(userId);
        if (user == null) {
            return null;
        }
        user.setNickname(nickname.trim());
        userMapper.updateById(user);
        return user;
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
        // 由数据库 GROUP BY 聚合（按时长降序），避免把全部历史行拉到内存
        List<com.fenglin.springboottest.dto.ListenAgg> aggs = historyMapper.listenAggregates();
        if (aggs.isEmpty()) {
            return new ArrayList<>();
        }

        // 一次性批量查询所有涉及的用户，消除 N+1
        List<Long> userIds = aggs.stream().map(com.fenglin.springboottest.dto.ListenAgg::getUserId)
                .filter(java.util.Objects::nonNull).distinct().toList();
        java.util.Map<Long, User> userMap = userIds.isEmpty()
                ? java.util.Collections.emptyMap()
                : userMapper.selectBatchIds(userIds).stream()
                        .collect(Collectors.toMap(User::getId, u -> u, (a, b) -> a));

        List<RankUserVO> result = new ArrayList<>();
        int rank = 1;
        for (com.fenglin.springboottest.dto.ListenAgg e : aggs) {
            User u = userMap.get(e.getUserId());
            if (u == null) {
                continue;
            }
            RankUserVO vo = new RankUserVO();
            vo.setRank(rank++);
            vo.setUserId(u.getId());
            vo.setNickname(u.getNickname() != null ? u.getNickname() : u.getAccount());
            String letter = vo.getNickname();
            vo.setAvatarLetter(letter == null || letter.isEmpty() ? "鲨" : letter.substring(0, 1));
            long sec = e.getTotalSeconds() != null ? e.getTotalSeconds() : 0;
            vo.setListenSeconds(sec);
            vo.setPlayCount(e.getPlayCount() != null ? e.getPlayCount() : 0);
            int level = SharkLevel.levelOf(sec);
            vo.setLevel(level);
            vo.setLevelName(SharkLevel.nameOf(level));
            result.add(vo);
        }
        return result;
    }

    @Override
    public List<MomentVO> moments(Long userId) {
        return moments(userId, userId);
    }

    @Override
    public List<MomentVO> moments(Long userId, Long viewerId) {
        List<UserMoment> list = momentMapper.selectList(Wrappers.<UserMoment>lambdaQuery()
                .eq(UserMoment::getUserId, userId)
                .orderByDesc(UserMoment::getCreateTime));
        if (list.isEmpty()) {
            return new ArrayList<>();
        }

        List<Long> momentIds = list.stream().map(UserMoment::getId).collect(Collectors.toList());

        // 批量预取涉及的歌曲与歌单，消除 N+1
        List<Long> songIds = list.stream().map(UserMoment::getSongId)
                .filter(java.util.Objects::nonNull).distinct().toList();
        java.util.Map<Long, Song> songMap = songIds.isEmpty()
                ? java.util.Collections.emptyMap()
                : songMapper.selectBatchIds(songIds).stream()
                        .collect(Collectors.toMap(Song::getId, s -> s, (a, b) -> a));

        List<Long> playlistIds = list.stream().map(UserMoment::getPlaylistId)
                .filter(java.util.Objects::nonNull).distinct().toList();
        java.util.Map<Long, Playlist> playlistMap = playlistIds.isEmpty()
                ? java.util.Collections.emptyMap()
                : playlistMapper.selectBatchIds(playlistIds).stream()
                        .collect(Collectors.toMap(Playlist::getId, p -> p, (a, b) -> a));

        // 批量统计每条动态的点赞数
        java.util.Map<Long, Long> likeCountMap = momentLikeMapper.selectList(
                        Wrappers.<UserMomentLike>lambdaQuery().in(UserMomentLike::getMomentId, momentIds))
                .stream().collect(Collectors.groupingBy(UserMomentLike::getMomentId, Collectors.counting()));
        // 当前查看者已点赞的动态 id 集合
        java.util.Set<Long> likedIds = (viewerId == null) ? java.util.Collections.emptySet()
                : momentLikeMapper.selectList(Wrappers.<UserMomentLike>lambdaQuery()
                        .in(UserMomentLike::getMomentId, momentIds)
                        .eq(UserMomentLike::getUserId, viewerId))
                        .stream().map(UserMomentLike::getMomentId).collect(Collectors.toSet());

        List<MomentVO> result = new ArrayList<>();
        for (UserMoment m : list) {
            MomentVO vo = new MomentVO();
            vo.setId(m.getId());
            vo.setType(m.getType());
            vo.setContent(m.getContent());
            if (m.getSongId() != null) {
                Song s = songMap.get(m.getSongId());
                vo.setSongTitle(s != null ? s.getTitle() : null);
            }
            if (m.getPlaylistId() != null) {
                Playlist p = playlistMap.get(m.getPlaylistId());
                vo.setPlaylistTitle(p != null ? p.getTitle() : null);
            }
            vo.setCreateTime(m.getCreateTime() != null ? m.getCreateTime().format(FMT) : "");
            Long lc = likeCountMap.get(m.getId());
            vo.setLikeCount(lc != null ? lc.intValue() : 0);
            vo.setLiked(likedIds.contains(m.getId()));
            result.add(vo);
        }
        return result;
    }

    @Override
    @Transactional
    public Boolean toggleMomentLike(Long userId, Long momentId) {
        if (momentMapper.selectById(momentId) == null) {
            return null; // 动态不存在
        }
        UserMomentLike exist = momentLikeMapper.selectOne(Wrappers.<UserMomentLike>lambdaQuery()
                .eq(UserMomentLike::getMomentId, momentId)
                .eq(UserMomentLike::getUserId, userId));
        if (exist != null) {
            momentLikeMapper.deleteById(exist.getId());
            return false; // 取消点赞
        }
        UserMomentLike like = new UserMomentLike();
        like.setMomentId(momentId);
        like.setUserId(userId);
        momentLikeMapper.insert(like);
        return true; // 点赞成功
    }

    @Override
    public MomentVO publishMoment(Long userId, String content) {
        if (content == null || content.trim().isEmpty()) {
            return null;
        }
        String text = content.trim();
        if (text.length() > 500) {
            text = text.substring(0, 500);
        }
        addMoment(userId, "post", text, null, null);
        UserMoment m = momentMapper.selectList(Wrappers.<UserMoment>lambdaQuery()
                        .eq(UserMoment::getUserId, userId)
                        .eq(UserMoment::getType, "post")
                        .eq(UserMoment::getContent, text)
                        .orderByDesc(UserMoment::getId))
                .stream().findFirst().orElse(null);
        if (m == null) {
            return null;
        }
        MomentVO vo = new MomentVO();
        vo.setId(m.getId());
        vo.setType(m.getType());
        vo.setContent(m.getContent());
        vo.setCreateTime(m.getCreateTime() != null ? m.getCreateTime().format(FMT) : "");
        return vo;
    }

    @Override
    public boolean deleteMoment(Long userId, Long momentId) {
        UserMoment m = momentMapper.selectById(momentId);
        if (m == null || !userId.equals(m.getUserId())) {
            return false;
        }
        momentMapper.deleteById(momentId);
        // 级联清理该动态的点赞记录，避免留下指向已删动态的孤儿数据
        momentLikeMapper.delete(Wrappers.<UserMomentLike>lambdaQuery()
                .eq(UserMomentLike::getMomentId, momentId));
        return true;
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

    /* ============ 个人歌单（按 user_id 隔离，用户互不可见） ============ */

    @Override
    public List<UserPlaylist> myPlaylists(Long userId) {
        List<UserPlaylist> list = userPlaylistMapper.selectList(Wrappers.<UserPlaylist>lambdaQuery()
                .eq(UserPlaylist::getUserId, userId)
                .orderByAsc(UserPlaylist::getSortOrder)
                .orderByAsc(UserPlaylist::getId));
        // 填充每个歌单的歌曲数量
        for (UserPlaylist p : list) {
            Long count = playlistSongMapper.selectCount(Wrappers.<UserPlaylistSong>lambdaQuery()
                    .eq(UserPlaylistSong::getPlaylistId, p.getId()));
            p.setSongCount(count != null ? count.intValue() : 0);
        }
        return list;
    }

    @Override
    public UserPlaylist createPlaylist(Long userId, String name, String coverTone) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("歌单名不能为空");
        }
        String n = name.trim();
        // 同用户名下歌单名查重
        Long exists = userPlaylistMapper.selectCount(Wrappers.<UserPlaylist>lambdaQuery()
                .eq(UserPlaylist::getUserId, userId)
                .eq(UserPlaylist::getName, n));
        if (exists != null && exists > 0) {
            return null; // 重名
        }
        UserPlaylist p = new UserPlaylist();
        p.setUserId(userId);
        p.setName(n);
        p.setCoverTone(coverTone != null && !coverTone.isBlank() ? coverTone : "p1");
        p.setSortOrder(0);
        userPlaylistMapper.insert(p);
        return p;
    }

    @Override
    public UserPlaylist renamePlaylist(Long userId, Long playlistId, String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("歌单名不能为空");
        }
        UserPlaylist p = userPlaylistMapper.selectOne(Wrappers.<UserPlaylist>lambdaQuery()
                .eq(UserPlaylist::getId, playlistId)
                .eq(UserPlaylist::getUserId, userId));
        if (p == null) {
            return null; // 不存在或不属于该用户
        }
        String n = name.trim();
        if (!n.equals(p.getName())) {
            Long exists = userPlaylistMapper.selectCount(Wrappers.<UserPlaylist>lambdaQuery()
                    .eq(UserPlaylist::getUserId, userId)
                    .eq(UserPlaylist::getName, n)
                    .ne(UserPlaylist::getId, playlistId));
            if (exists != null && exists > 0) {
                throw new IllegalArgumentException("已存在同名歌单：" + n);
            }
        }
        p.setName(n);
        userPlaylistMapper.updateById(p);
        return p;
    }

    @Override
    public boolean deletePlaylist(Long userId, Long playlistId) {
        UserPlaylist p = userPlaylistMapper.selectOne(Wrappers.<UserPlaylist>lambdaQuery()
                .eq(UserPlaylist::getId, playlistId)
                .eq(UserPlaylist::getUserId, userId));
        if (p == null) {
            return false;
        }
        userPlaylistMapper.deleteById(playlistId);
        // 一并清理该歌单的歌曲关联，避免残留脏数据
        playlistSongMapper.delete(Wrappers.<UserPlaylistSong>lambdaQuery()
                .eq(UserPlaylistSong::getPlaylistId, playlistId));
        return true;
    }

    /* ============ 个人歌单内的歌曲（增删改查） ============ */

    /** 校验歌单归属，返回歌单实体；不存在或不属于该用户返回 null */
    private UserPlaylist ownedPlaylist(Long userId, Long playlistId) {
        if (playlistId == null) return null;
        return userPlaylistMapper.selectOne(Wrappers.<UserPlaylist>lambdaQuery()
                .eq(UserPlaylist::getId, playlistId)
                .eq(UserPlaylist::getUserId, userId));
    }

    @Override
    public List<Song> playlistSongs(Long userId, Long playlistId) {
        if (ownedPlaylist(userId, playlistId) == null) {
            return null; // 歌单不存在或不属于该用户
        }
        List<UserPlaylistSong> links = playlistSongMapper.selectList(
                Wrappers.<UserPlaylistSong>lambdaQuery()
                        .eq(UserPlaylistSong::getPlaylistId, playlistId)
                        .orderByAsc(UserPlaylistSong::getSortOrder)
                        .orderByAsc(UserPlaylistSong::getId));
        if (links.isEmpty()) {
            return new ArrayList<>();
        }
        List<Long> songIds = links.stream().map(UserPlaylistSong::getSongId).collect(Collectors.toList());
        List<Song> songs = songMapper.selectBatchIds(songIds);
        // 按歌单中的排序返回
        java.util.Map<Long, Song> songMap = songs.stream()
                .collect(Collectors.toMap(Song::getId, s -> s, (a, b) -> a));
        List<Song> ordered = new ArrayList<>();
        for (Long sid : songIds) {
            Song s = songMap.get(sid);
            if (s != null) ordered.add(s);
        }
        return ordered;
    }

    @Override
    @Transactional
    public int addPlaylistSong(Long userId, Long playlistId, Long songId) {
        if (songId == null || songMapper.selectById(songId) == null) {
            return 0; // 歌曲不存在
        }
        if (ownedPlaylist(userId, playlistId) == null) {
            return -1; // 歌单不存在或不属于该用户
        }
        Long exists = playlistSongMapper.selectCount(Wrappers.<UserPlaylistSong>lambdaQuery()
                .eq(UserPlaylistSong::getPlaylistId, playlistId)
                .eq(UserPlaylistSong::getSongId, songId));
        if (exists != null && exists > 0) {
            return 0; // 已在歌单中
        }
        Integer maxOrder = playlistSongMapper.selectList(Wrappers.<UserPlaylistSong>lambdaQuery()
                        .eq(UserPlaylistSong::getPlaylistId, playlistId)
                        .orderByDesc(UserPlaylistSong::getSortOrder))
                .stream().map(UserPlaylistSong::getSortOrder)
                .filter(java.util.Objects::nonNull)
                .findFirst().orElse(0);
        UserPlaylistSong link = new UserPlaylistSong();
        link.setPlaylistId(playlistId);
        link.setSongId(songId);
        link.setSortOrder((maxOrder == null ? 0 : maxOrder) + 1);
        playlistSongMapper.insert(link);
        return 1;
    }

    @Override
    public boolean removePlaylistSong(Long userId, Long playlistId, Long songId) {
        if (ownedPlaylist(userId, playlistId) == null) {
            return false;
        }
        playlistSongMapper.delete(Wrappers.<UserPlaylistSong>lambdaQuery()
                .eq(UserPlaylistSong::getPlaylistId, playlistId)
                .eq(UserPlaylistSong::getSongId, songId));
        return true;
    }

    @Override
    public UserProfileVO visitProfile(Long viewerId, Long targetId) {
        User user = userMapper.selectById(targetId);
        if (user == null) {
            return null;
        }
        UserProfileVO vo = new UserProfileVO();
        vo.setId(user.getId());
        vo.setAccount(user.getAccount());
        vo.setNickname(user.getNickname() != null ? user.getNickname() : user.getAccount());
        vo.setAvatar(user.getAvatar());
        vo.setUid(user.getUid());

        vo.setFollowing(followMapper.selectCount(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFollowerId, targetId)));
        vo.setFollowers(followMapper.selectCount(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFolloweeId, targetId)));
        vo.setFavoriteCount(favoriteMapper.selectCount(Wrappers.<UserFavorite>lambdaQuery()
                .eq(UserFavorite::getUserId, targetId)));
        vo.setPlayCount(historyMapper.selectCount(Wrappers.<PlayHistory>lambdaQuery()
                .eq(PlayHistory::getUserId, targetId)));

        long sec = sumListenSeconds(targetId);
        vo.setListenSeconds(sec);
        int level = SharkLevel.levelOf(sec);
        vo.setLevel(level);
        vo.setLevelName(SharkLevel.nameOf(level));
        vo.setNextLevelSeconds(SharkLevel.nextLevelSeconds(sec));
        vo.setProgress(SharkLevel.progressOf(sec));

        // 浏览者是否关注了对方
        long f = followMapper.selectCount(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFollowerId, viewerId)
                .eq(UserFollow::getFolloweeId, targetId));
        vo.setFollowed(f > 0);

        // 对方是否也关注了浏览者（互相关注 = 好友）
        long back = followMapper.selectCount(Wrappers.<UserFollow>lambdaQuery()
                .eq(UserFollow::getFollowerId, targetId)
                .eq(UserFollow::getFolloweeId, viewerId));
        vo.setMutualFollow(back > 0);

        return vo;
    }
}
