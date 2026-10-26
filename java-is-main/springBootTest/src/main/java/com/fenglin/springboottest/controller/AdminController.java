package com.fenglin.springboottest.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.common.JwtUtil;
import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.AuthRequest;
import com.fenglin.springboottest.entity.Audiobook;
import com.fenglin.springboottest.entity.Channel;
import com.fenglin.springboottest.entity.Chart;
import com.fenglin.springboottest.entity.ChartSong;
import com.fenglin.springboottest.entity.Playlist;
import com.fenglin.springboottest.entity.Singer;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.mapper.AudiobookMapper;
import com.fenglin.springboottest.mapper.ChannelMapper;
import com.fenglin.springboottest.mapper.ChartMapper;
import com.fenglin.springboottest.mapper.ChartSongMapper;
import com.fenglin.springboottest.mapper.PlaylistMapper;
import com.fenglin.springboottest.mapper.SingerMapper;
import com.fenglin.springboottest.mapper.SongMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 后台管理系统接口（管理员专属）。
 * 前缀 /api/admin：登录公开，其余接口需携带管理员 Bearer token。
 * 统一管理首页展示内容：歌曲 / 歌单 / 榜单 / 歌手 / 频道 / 听书，以及榜单歌曲。
 */
@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired private SongMapper songMapper;
    @Autowired private PlaylistMapper playlistMapper;
    @Autowired private ChartMapper chartMapper;
    @Autowired private SingerMapper singerMapper;
    @Autowired private ChannelMapper channelMapper;
    @Autowired private AudiobookMapper audiobookMapper;
    @Autowired private ChartSongMapper chartSongMapper;

    @Autowired private JwtUtil jwtUtil;

    @Value("${shark.admin.account}")
    private String adminAccount;
    @Value("${shark.admin.password}")
    private String adminPassword;

    private final ObjectMapper om = new ObjectMapper();

    /* ============ 管理员登录（公开） ============ */
    @PostMapping("/login")
    public ResponseEntity<Result<?>> login(@RequestBody AuthRequest req) {
        if (req == null
                || !adminAccount.equals(req.getAccount())
                || !adminPassword.equals(req.getPassword())) {
            return ResponseEntity.status(401).body(Result.fail(401, "管理员账号或密码错误"));
        }
        String token = jwtUtil.generateToken(adminAccount);
        Map<String, String> data = new HashMap<>();
        data.put("token", token);
        data.put("account", adminAccount);
        return ResponseEntity.ok(Result.ok("管理员登录成功 🛠️", data));
    }

    /* ============ 鉴权辅助：校验 Bearer token 且为管理员 ============ */
    private String authAccount(HttpServletRequest request) {
        String h = request.getHeader("Authorization");
        if (h == null || !h.startsWith("Bearer ")) return null;
        String token = h.substring(7).trim();
        if (!jwtUtil.validate(token)) return null;
        try {
            String acc = jwtUtil.parseAccount(token);
            return adminAccount.equals(acc) ? acc : null;
        } catch (Exception e) {
            return null;
        }
    }

    private ResponseEntity<Result<?>> needAuth(HttpServletRequest request) {
        if (authAccount(request) == null) {
            return ResponseEntity.status(401).body(Result.fail(401, "管理员未登录或登录已过期"));
        }
        return null;
    }

    /* ============ 通用 CRUD 元数据 ============ */
    private static final class Meta {
        final BaseMapper mapper;     // 原始类型，便于通用增删改
        final Class<?> clazz;
        final String orderBy;        // 列表排序字段，逗号分隔
        Meta(BaseMapper m, Class<?> c, String o) { mapper = m; clazz = c; orderBy = o; }
    }

    private Meta meta(String type) {
        return switch (type) {
            case "song"       -> new Meta(songMapper, Song.class, "id");
            case "playlist"   -> new Meta(playlistMapper, Playlist.class, "sort_order,id");
            case "chart"      -> new Meta(chartMapper, Chart.class, "sort_order,id");
            case "singer"     -> new Meta(singerMapper, Singer.class, "sort_order,id");
            case "channel"    -> new Meta(channelMapper, Channel.class, "sort_order,id");
            case "audiobook"  -> new Meta(audiobookMapper, Audiobook.class, "sort_order,id");
            default           -> null;
        };
    }

    /* ============ 列表 ============ */
    @GetMapping("/{type}")
    public ResponseEntity<Result<?>> list(@PathVariable String type, HttpServletRequest request) {
        ResponseEntity<Result<?>> err = needAuth(request);
        if (err != null) return err;
        Meta m = meta(type);
        if (m == null) return ResponseEntity.badRequest().body(Result.fail(400, "未知的数据类型：" + type));
        QueryWrapper<Object> qw = new QueryWrapper<>();
        for (String col : m.orderBy.split(",")) qw.orderByAsc(col.trim());
        return ResponseEntity.ok(Result.ok("列表", m.mapper.selectList(qw)));
    }

    /* ============ 新增 ============ */
    @PostMapping("/{type}")
    public ResponseEntity<Result<?>> create(@PathVariable String type,
                                            @RequestBody Map<String, Object> body,
                                            HttpServletRequest request) {
        ResponseEntity<Result<?>> err = needAuth(request);
        if (err != null) return err;
        Meta m = meta(type);
        if (m == null) return ResponseEntity.badRequest().body(Result.fail(400, "未知的数据类型：" + type));
        body.remove("id");
        body.remove("createTime");
        body.remove("updateTime");
        body.remove("deleted");
        try {
            Object entity = om.readValue(om.writeValueAsString(body), m.clazz);
            m.mapper.insert(entity);
            return ResponseEntity.ok(Result.ok("新增成功", entity));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Result.fail(400, "参数格式有误：" + e.getMessage()));
        }
    }

    /* ============ 更新 ============ */
    @PutMapping("/{type}")
    public ResponseEntity<Result<?>> update(@PathVariable String type,
                                            @RequestBody Map<String, Object> body,
                                            HttpServletRequest request) {
        ResponseEntity<Result<?>> err = needAuth(request);
        if (err != null) return err;
        Meta m = meta(type);
        if (m == null) return ResponseEntity.badRequest().body(Result.fail(400, "未知的数据类型：" + type));
        body.remove("createTime");
        body.remove("updateTime");
        body.remove("deleted");
        try {
            Object entity = om.readValue(om.writeValueAsString(body), m.clazz);
            m.mapper.updateById(entity);
            return ResponseEntity.ok(Result.ok("更新成功", entity));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Result.fail(400, "参数格式有误：" + e.getMessage()));
        }
    }

    /* ============ 删除（逻辑删除，依赖 @TableLogic） ============ */
    @DeleteMapping("/{type}/{id}")
    public ResponseEntity<Result<?>> delete(@PathVariable String type,
                                            @PathVariable Long id,
                                            HttpServletRequest request) {
        ResponseEntity<Result<?>> err = needAuth(request);
        if (err != null) return err;
        Meta m = meta(type);
        if (m == null) return ResponseEntity.badRequest().body(Result.fail(400, "未知的数据类型：" + type));
        m.mapper.deleteById(id);
        return ResponseEntity.ok(Result.ok("删除成功", null));
    }

    /* ============ 榜单歌曲管理 ============ */
    @GetMapping("/chart-songs")
    public ResponseEntity<Result<?>> chartSongs(@RequestParam Long chartId, HttpServletRequest request) {
        ResponseEntity<Result<?>> err = needAuth(request);
        if (err != null) return err;
        QueryWrapper<ChartSong> qw = new QueryWrapper<>();
        qw.eq("chart_id", chartId).orderByAsc("rank_no");
        return ResponseEntity.ok(Result.ok("榜单歌曲", chartSongMapper.selectList(qw)));
    }

    @PostMapping("/chart-songs")
    public ResponseEntity<Result<?>> addChartSong(@RequestBody ChartSong cs, HttpServletRequest request) {
        ResponseEntity<Result<?>> err = needAuth(request);
        if (err != null) return err;
        cs.setId(null);
        chartSongMapper.insert(cs);
        return ResponseEntity.ok(Result.ok("已加入榜单", cs));
    }

    @PutMapping("/chart-songs")
    public ResponseEntity<Result<?>> updateChartSong(@RequestBody ChartSong cs, HttpServletRequest request) {
        ResponseEntity<Result<?>> err = needAuth(request);
        if (err != null) return err;
        chartSongMapper.updateById(cs);
        return ResponseEntity.ok(Result.ok("已更新", cs));
    }

    @DeleteMapping("/chart-songs/{id}")
    public ResponseEntity<Result<?>> deleteChartSong(@PathVariable Long id, HttpServletRequest request) {
        ResponseEntity<Result<?>> err = needAuth(request);
        if (err != null) return err;
        chartSongMapper.deleteById(id);
        return ResponseEntity.ok(Result.ok("已移除", null));
    }
}
