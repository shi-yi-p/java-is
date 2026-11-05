package com.fenglin.springboottest.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.fenglin.springboottest.entity.Song;
import com.fenglin.springboottest.mapper.SongMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.UnsupportedAudioFileException;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Arrays;

/**
 * 演示用合成音源接口：GET /api/stream?id=xxx
 *
 * 曲库 song 表只有元数据（歌名/歌手/专辑/时长），并无真实音频文件。
 * 为了让播放器「能出声」、进度条真实走动，这里按歌曲 id + 时长合成一段
 * 舒缓的旋律 WAV（每首歌音调随 id 不同而不同），并支持 HTTP Range 请求，
 * 使浏览器 <audio> 可以拖进度、暂停、seek。
 *
 * 公开接口（不经过 JWT 拦截器）。
 */
@RestController
@RequestMapping("/api")
public class StreamController {

    /** 采样率 22050Hz、单声道、16bit PCM */
    private static final float SAMPLE_RATE = 22050f;

    /** 单次可合成的最大时长（秒），防止传入超大 duration 撑爆内存 */
    private static final int MAX_SECONDS = 600;

    @Autowired
    private SongMapper songMapper;

    /**
     * 返回歌曲音频，支持 Range: bytes=start-end 请求头。
     *
     * 解析优先级（A+B 方案）：
     *   1) 真实音源：song 表有 url 字段（指向真实 mp3 直链）→ 302 重定向到该地址；
     *   2) 免费公开音源：命中内置「歌名→免费 mp3」映射表 → 302 重定向；
     *   3) 合成音源：以上都未命中 → 按歌曲 id 合成 WAV 兜底（保证一定能出声）。
     */
    @GetMapping("/stream")
    public ResponseEntity<?> stream(
            @RequestParam(required = false) Long id,
            @RequestParam(required = false) Integer duration,
            @RequestHeader(value = "Range", required = false) String range) {

        Song song = null;
        if (id != null) {
            song = songMapper.selectById(id);
        }

        // 1) 歌曲自身带真实音源地址（song.url）→ 重定向
        if (song != null && hasText(song.getUrl())) {
            return redirect(song.getUrl());
        }

        // 2) 免费公开音源映射：歌名/歌手命中内置表 → 重定向到免费 mp3
        if (song != null) {
            String free = freeSourceUrl(song);
            if (free != null) {
                return redirect(free);
            }
        }

        // 3) 合成音源兜底
        // 时长：优先用歌曲真实时长，其次用请求参数，兜底 30 秒
        int seconds = 30;
        if (song != null && song.getDuration() != null && song.getDuration() > 0) {
            seconds = song.getDuration();
        } else if (duration != null && duration > 0) {
            seconds = duration;
        }
        seconds = Math.min(seconds, MAX_SECONDS);

        // 歌曲标识：有歌用歌的 id，否则用 id 参数，兜底 1
        long seed = (song != null && song.getId() != null) ? song.getId() : (id != null ? id : 1L);

        byte[] wav = synthWav(seed, seconds);

        return buildResponse(wav, range);
    }

    private boolean hasText(String s) {
        return s != null && !s.trim().isEmpty();
    }

    /** 302 重定向到真实音频地址 */
    private ResponseEntity<?> redirect(String url) {
        HttpHeaders headers = new HttpHeaders();
        headers.setLocation(java.net.URI.create(url));
        return new ResponseEntity<>(headers, HttpStatus.FOUND);
    }

    /**
     * 免费公开音源映射：将「歌名/歌手」映射到免费可直链的 mp3。
     *
     * 注意：曲库歌曲为虚构的「鲨鱼音乐」世界观，真实音乐平台上并无对应曲目，
     * 因此这里默认返回 null（走合成音源）。若你有可用的免费 mp3 直链
     * （如自己上传到图床/对象存储/公开 CDN 的试听片段），按下面示例填入即可：
     *
     *   freeSourceMap.put("潮汐信号", "https://你的域名/audio/chaoxi.mp3");
     *
     * 匹配规则：先精确匹配歌名，再匹配「歌手-歌名」组合。
     */
    private String freeSourceUrl(Song song) {
        String title = song.getTitle() == null ? "" : song.getTitle().trim();
        String artist = song.getArtist() == null ? "" : song.getArtist().trim();

        java.util.Map<String, String> map = new java.util.LinkedHashMap<>();
        // 示例（未启用）：下方注释掉真实链接占位
        // map.put("潮汐信号", "https://example.com/audio/chaoxi.mp3");

        // 精确歌名命中
        if (map.containsKey(title)) {
            return map.get(title);
        }
        // 「歌手 - 歌名」组合命中
        String key = artist + " - " + title;
        if (map.containsKey(key)) {
            return map.get(key);
        }
        return null;
    }

    /**
     * 合成 WAV：以 seed 为随机种子的确定性旋律，同一首歌每次生成完全一致。
     * 波形 = 若干正弦波叠加（基音 + 泛音），附缓慢的包络与颤音，听感柔和。
     */
    private byte[] synthWav(long seed, int seconds) {
        int sampleRate = (int) SAMPLE_RATE;
        int total = sampleRate * seconds;

        // 每首歌的音阶种子：根据 seed 从五声音阶里挑一个主音（听起来像东方小调）
        java.util.Random rand = new java.util.Random(seed);
        double base = 196.0 * Math.pow(2.0, (rand.nextInt(12)) / 12.0); // G3 附近随机主音
        double[] pentatonic = { 0, 2, 4, 7, 9 }; // 五声音阶（半音差）

        // 每个音符约 0.4 秒，循环变化
        int noteSamples = (int) (sampleRate * 0.4);
        int noteIndex = 0;

        ByteArrayOutputStream bos = new ByteArrayOutputStream(total * 2 + 44);

        for (int i = 0; i < total; i++) {
            int n = i / noteSamples;
            // 音符序列：在五声音阶上随机漫步，保证旋律连贯
            if (n != noteIndex) {
                noteIndex = n;
            }
            int step = (int) pentatonic[rand.nextInt(pentatonic.length)];
            double freq = base * Math.pow(2.0, step / 12.0) * (0.5 + (noteIndex % 2) * 0.25);

            double t = i / SAMPLE_RATE;
            double env = 0.85 + 0.15 * Math.sin(2 * Math.PI * 0.25 * t); // 缓慢起伏
            double vibrato = 1.0 + 0.003 * Math.sin(2 * Math.PI * 5.0 * t);

            // 基音 + 2/3 次泛音叠加，更接近竖琴/木琴质感
            double v = Math.sin(2 * Math.PI * freq * vibrato * t)
                    + 0.4 * Math.sin(2 * Math.PI * freq * 2.0 * t)
                    + 0.15 * Math.sin(2 * Math.PI * freq * 3.0 * t);

            // 单音符包络（淡入淡出），避免爆音
            double posInNote = (i % noteSamples) / (double) noteSamples;
            double noteEnv = Math.min(1.0, Math.min(posInNote * 20.0, (1.0 - posInNote) * 20.0));

            // 整体音量 0.22，留出余量
            double sample = v * env * noteEnv * 0.22;

            short s = (short) (sample * Short.MAX_VALUE);
            bos.write(s & 0xFF);
            bos.write((s >> 8) & 0xFF);
        }

        return toWav(bos.toByteArray(), sampleRate);
    }

    /** 给裸 PCM 加上 44 字节 WAV 头 */
    private byte[] toWav(byte[] pcm, int sampleRate) {
        int dataLen = pcm.length;
        int chunkSize = 36 + dataLen;
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        try {
            out.write("RIFF".getBytes());
            writeIntLE(out, chunkSize);
            out.write("WAVE".getBytes());
            out.write("fmt ".getBytes());
            writeIntLE(out, 16);                       // fmt 块大小
            writeShortLE(out, (short) 1);              // PCM
            writeShortLE(out, (short) 1);              // 单声道
            writeIntLE(out, sampleRate);
            writeIntLE(out, sampleRate * 2);           // 字节率 = 采样率 * 2(字节/采样)
            writeShortLE(out, (short) 2);              // 块对齐
            writeShortLE(out, (short) 16);             // 位深
            out.write("data".getBytes());
            writeIntLE(out, dataLen);
            out.write(pcm);
        } catch (IOException e) {
            throw new RuntimeException("WAV 头写入失败", e);
        }
        return out.toByteArray();
    }

    private void writeIntLE(ByteArrayOutputStream out, int v) {
        out.write(v & 0xFF);
        out.write((v >> 8) & 0xFF);
        out.write((v >> 16) & 0xFF);
        out.write((v >> 24) & 0xFF);
    }

    private void writeShortLE(ByteArrayOutputStream out, short v) {
        out.write(v & 0xFF);
        out.write((v >> 8) & 0xFF);
    }

    /** 构造响应，处理 Range 请求（支持拖动进度条） */
    private ResponseEntity<byte[]> buildResponse(byte[] full, String range) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("audio/wav"));
        headers.set(HttpHeaders.ACCEPT_RANGES, "bytes");
        headers.set(HttpHeaders.CACHE_CONTROL, "public, max-age=3600");

        int total = full.length;

        if (range != null && range.startsWith("bytes=")) {
            String[] parts = range.substring(6).split("-");
            long start = parts.length > 0 && !parts[0].isEmpty() ? Long.parseLong(parts[0]) : 0;
            long end = parts.length > 1 && !parts[1].isEmpty() ? Long.parseLong(parts[1]) : total - 1;
            start = Math.max(0, Math.min(start, total - 1));
            end = Math.max(start, Math.min(end, total - 1));

            byte[] slice = Arrays.copyOfRange(full, (int) start, (int) end + 1);
            headers.setContentLength(slice.length);
            headers.set(HttpHeaders.CONTENT_RANGE, "bytes " + start + "-" + end + "/" + total);
            return new ResponseEntity<>(slice, headers, HttpStatus.PARTIAL_CONTENT);
        }

        headers.setContentLength(total);
        return new ResponseEntity<>(full, headers, HttpStatus.OK);
    }
}
