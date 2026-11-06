package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.entity.DouyinHotSong;
import com.fenglin.springboottest.entity.KugouHotSong;
import com.fenglin.springboottest.entity.NeteaseHotSong;
import com.fenglin.springboottest.entity.QqHotSong;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.mapper.DouyinHotSongMapper;
import com.fenglin.springboottest.mapper.KugouHotSongMapper;
import com.fenglin.springboottest.mapper.NeteaseHotSongMapper;
import com.fenglin.springboottest.mapper.QqHotSongMapper;
import com.fenglin.springboottest.mapper.SongMapper;
import com.fenglin.springboottest.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 曲库搜索服务实现
 *
 * 搜索范围：song 主曲库（虚构「鲨鱼音乐」歌曲）+ 四个热歌榜（酷狗/网易云/QQ/抖音）
 * 里的真实经典金曲（晴天、稻香、周杰伦 等）。
 *
 * 这样用户在搜索栏搜「晴天」「周杰伦」等真实歌名时也能命中，
 * 而不是只能搜到虚构曲库里的歌。
 */
@Service
public class SearchServiceImpl implements SearchService {

    /** 单次搜索最多返回条数 */
    private static final int LIMIT = 20;

    /** 热歌榜歌曲的 id 偏移量，避免与 song 主表（id 1~30）冲突，保证合成音源 seed 唯一 */
    private static final long HOT_SONG_ID_BASE = 100000L;

    @Autowired
    private SongMapper songMapper;

    @Autowired
    private KugouHotSongMapper kugouHotSongMapper;

    @Autowired
    private NeteaseHotSongMapper neteaseHotSongMapper;

    @Autowired
    private QqHotSongMapper qqHotSongMapper;

    @Autowired
    private DouyinHotSongMapper douyinHotSongMapper;

    @Override
    public List<Song> search(String keyword) {
        List<Song> result = new ArrayList<>();

        // 1) 主曲库（虚构歌曲）
        result.addAll(songMapper.selectList(
                new LambdaQueryWrapper<Song>()
                        .and(w -> w.like(Song::getTitle, keyword)
                                .or().like(Song::getArtist, keyword)
                                .or().like(Song::getAlbum, keyword))
                        .orderByDesc(Song::getPlays)));

        // 2) 四个热歌榜（真实金曲），按热度排序
        result.addAll(toSongs(kugouHotSongMapper.selectList(
                new LambdaQueryWrapper<KugouHotSong>()
                        .and(w -> w.like(KugouHotSong::getTitle, keyword)
                                .or().like(KugouHotSong::getArtist, keyword)
                                .or().like(KugouHotSong::getAlbum, keyword))
                        .orderByDesc(KugouHotSong::getHotValue))));

        result.addAll(toSongs(neteaseHotSongMapper.selectList(
                new LambdaQueryWrapper<NeteaseHotSong>()
                        .and(w -> w.like(NeteaseHotSong::getTitle, keyword)
                                .or().like(NeteaseHotSong::getArtist, keyword)
                                .or().like(NeteaseHotSong::getAlbum, keyword))
                        .orderByDesc(NeteaseHotSong::getHotValue))));

        result.addAll(toSongs(qqHotSongMapper.selectList(
                new LambdaQueryWrapper<QqHotSong>()
                        .and(w -> w.like(QqHotSong::getTitle, keyword)
                                .or().like(QqHotSong::getArtist, keyword)
                                .or().like(QqHotSong::getAlbum, keyword))
                        .orderByDesc(QqHotSong::getHotValue))));

        result.addAll(toSongs(douyinHotSongMapper.selectList(
                new LambdaQueryWrapper<DouyinHotSong>()
                        .and(w -> w.like(DouyinHotSong::getTitle, keyword)
                                .or().like(DouyinHotSong::getArtist, keyword)
                                .or().like(DouyinHotSong::getAlbum, keyword))
                        .orderByDesc(DouyinHotSong::getHotValue))));

        // 截断到上限
        if (result.size() > LIMIT) {
            return result.subList(0, LIMIT);
        }
        return result;
    }

    /** 把热歌榜实体统一映射成 Song 结构，id 加偏移避免与主曲库冲突 */
    private List<Song> toSongs(List<?> list) {
        List<Song> out = new ArrayList<>();
        for (Object o : list) {
            String title = null, artist = null, album = null;
            Integer duration = null;
            Long id = null;

            if (o instanceof KugouHotSong) {
                KugouHotSong s = (KugouHotSong) o;
                id = s.getId(); title = s.getTitle(); artist = s.getArtist();
                album = s.getAlbum(); duration = s.getDuration();
            } else if (o instanceof NeteaseHotSong) {
                NeteaseHotSong s = (NeteaseHotSong) o;
                id = s.getId(); title = s.getTitle(); artist = s.getArtist();
                album = s.getAlbum(); duration = s.getDuration();
            } else if (o instanceof QqHotSong) {
                QqHotSong s = (QqHotSong) o;
                id = s.getId(); title = s.getTitle(); artist = s.getArtist();
                album = s.getAlbum(); duration = s.getDuration();
            } else if (o instanceof DouyinHotSong) {
                DouyinHotSong s = (DouyinHotSong) o;
                id = s.getId(); title = s.getTitle(); artist = s.getArtist();
                album = s.getAlbum(); duration = s.getDuration();
            }

            Song song = new Song();
            song.setId(HOT_SONG_ID_BASE + (id != null ? id : 0));
            song.setTitle(title);
            song.setArtist(artist);
            song.setAlbum(album);
            song.setDuration(duration != null ? duration : 0);
            out.add(song);
        }
        return out;
    }
}
