package com.fenglin.springboottest.common;

import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.mapper.SongMapper;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;
import java.util.function.BiConsumer;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * 歌曲 id 解析器：把热歌榜等来源的歌曲按「标题 + 歌手」反查到主曲库 song 表，
 * 得到统一的 songId，供收藏 / 播放记录引用，避免各来源表自增 id 冲突。
 */
@Component
public class SongIdResolver {

    private final SongMapper songMapper;

    public SongIdResolver(SongMapper songMapper) {
        this.songMapper = songMapper;
    }

    /**
     * 批量填充 songId。
     *
     * @param items        待填充的歌曲列表
     * @param titleGetter  取标题
     * @param artistGetter 取歌手
     * @param setter       写入 songId
     */
    public <T> void fillSongIds(List<T> items,
                                Function<T, String> titleGetter,
                                Function<T, String> artistGetter,
                                BiConsumer<T, Long> setter) {
        if (items == null || items.isEmpty()) {
            return;
        }
        // 按标题 + 歌手反查主曲库（一次查询，避免 N+1）
        List<String> titles = items.stream().map(titleGetter)
                .filter(java.util.Objects::nonNull).distinct().toList();
        if (titles.isEmpty()) {
            return;
        }
        List<Song> songs = songMapper.selectList(
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Song>()
                        .in(Song::getTitle, titles));
        Map<String, Song> byKey = songs.stream()
                .collect(Collectors.toMap(
                        s -> keyOf(s.getTitle(), s.getArtist()),
                        s -> s,
                        (a, b) -> a));

        for (T item : items) {
            Song s = byKey.get(keyOf(titleGetter.apply(item), artistGetter.apply(item)));
            if (s != null && s.getId() != null) {
                setter.accept(item, s.getId());
            }
        }
    }

    private String keyOf(String title, String artist) {
        return (title == null ? "" : title.trim()) + "\u0000" + (artist == null ? "" : artist.trim());
    }
}
