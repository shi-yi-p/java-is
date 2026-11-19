package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.mapper.SongMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 歌词接口：GET /api/lyric?id=xxx
 *
 * song 表新增 lyric 字段，存 LRC 格式歌词（带 [mm:ss.xx] 时间戳的原创歌词）。
 * 本接口把 LRC 解析成前端可直接渲染的行结构 [{t, text}]，便于 NowPlaying 逐行高亮。
 *
 * 公开接口（不经过 JWT 拦截器），与 /api/stream 一致。
 */
@RestController
@RequestMapping("/api")
public class LyricController {

    @Autowired
    private SongMapper songMapper;

    /** LRC 时间戳行：匹配 [mm:ss] 或 [mm:ss.xx] */
    private static final Pattern LRC_LINE = Pattern.compile("^\\[(\\d{1,2}):(\\d{1,2})(?:\\.(\\d{1,3}))?\\](.*)$");

    /**
     * 返回歌曲歌词。
     * - id 缺省或歌曲不存在：返回空列表
     * - 歌曲有 lyric：解析为 [{t:秒, text:歌词}] 返回
     * - 歌曲无 lyric：返回空列表（前端据此隐藏歌词区）
     */
    @GetMapping("/lyric")
    public Result<Map<String, Object>> lyric(@RequestParam(required = false) Long id) {
        List<Map<String, Object>> lines = new ArrayList<>();

        if (id != null) {
            Song song = songMapper.selectById(id);
            if (song != null && song.getLyric() != null && !song.getLyric().trim().isEmpty()) {
                lines = parseLrc(song.getLyric());
            }
        }

        Map<String, Object> data = new HashMap<>();
        data.put("id", id);
        data.put("lines", lines);
        return Result.ok("歌词", data);
    }

    /**
     * 解析 LRC 文本为 [{t: 秒, text: 歌词}]。
     * 不识别时间戳的行（如 LRC 元信息 [ti:]、[ar:]）会被跳过。
     */
    private List<Map<String, Object>> parseLrc(String lrc) {
        List<Map<String, Object>> lines = new ArrayList<>();
        for (String raw : lrc.split("\\r?\\n")) {
            String line = raw.trim();
            if (line.isEmpty()) {
                continue;
            }
            Matcher m = LRC_LINE.matcher(line);
            if (!m.matches()) {
                continue;
            }
            int min = Integer.parseInt(m.group(1));
            int sec = Integer.parseInt(m.group(2));
            String text = m.group(4).trim();
            if (text.isEmpty()) {
                continue;
            }
            double t = min * 60 + sec;
            if (m.group(3) != null && !m.group(3).isEmpty()) {
                // 毫秒部分：取前两位小数
                String ms = m.group(3);
                double frac = 0;
                if (ms.length() >= 2) {
                    frac = Integer.parseInt(ms.substring(0, 2)) / 100.0;
                } else {
                    frac = Integer.parseInt(ms) / 10.0;
                }
                t += frac;
            }
            Map<String, Object> item = new HashMap<>();
            item.put("t", t);
            item.put("text", text);
            lines.add(item);
        }
        return lines;
    }
}
