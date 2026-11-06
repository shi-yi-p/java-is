package com.fenglin.springboottest.common;

/**
 * 鲨鱼等级系统：根据累计听歌时长（秒）划分等级。
 *
 * 等级设定（贴合「鲨鱼音乐」世界观，从鱼卵到深海霸主）：
 *   Lv.1  鱼卵       0 分钟
 *   Lv.2  小鱼苗    10 分钟
 *   Lv.3  小鲨鱼    1 小时
 *   Lv.4  猎手鲨    6 小时
 *   Lv.5  深潜者    24 小时（1 天）
 *   Lv.6  巡洋舰鲨  100 小时
 *   Lv.7  深渊领主  500 小时
 *   Lv.8  深海霸主  2000 小时
 *   Lv.9  海洋传说  10000 小时
 *   Lv.10 鲨鱼之神  50000 小时
 */
public final class SharkLevel {

    private SharkLevel() {
    }

    /** 每级所需累计听歌秒数的阈值（下标 = 等级 - 1） */
    private static final long[] THRESHOLDS = {
            0L,                 // Lv.1 鱼卵
            10L * 60,           // Lv.2 小鱼苗
            60L * 60,           // Lv.3 小鲨鱼
            6L * 3600,          // Lv.4 猎手鲨
            24L * 3600,         // Lv.5 深潜者
            100L * 3600,        // Lv.6 巡洋舰鲨
            500L * 3600,        // Lv.7 深渊领主
            2000L * 3600,       // Lv.8 深海霸主
            10000L * 3600,      // Lv.9 海洋传说
            50000L * 3600       // Lv.10 鲨鱼之神
    };

    private static final String[] NAMES = {
            "鱼卵", "小鱼苗", "小鲨鱼", "猎手鲨", "深潜者",
            "巡洋舰鲨", "深渊领主", "深海霸主", "海洋传说", "鲨鱼之神"
    };

    /** 最大等级 */
    public static final int MAX_LEVEL = 10;

    /**
     * 根据累计听歌秒数计算等级（1~10）。
     */
    public static int levelOf(long listenSeconds) {
        long s = Math.max(0, listenSeconds);
        for (int i = THRESHOLDS.length - 1; i >= 0; i--) {
            if (s >= THRESHOLDS[i]) {
                return i + 1;
            }
        }
        return 1;
    }

    /**
     * 等级名称。
     */
    public static String nameOf(int level) {
        int idx = Math.max(0, Math.min(MAX_LEVEL - 1, level - 1));
        return NAMES[idx];
    }

    /**
     * 距离下一等级还需的秒数（满级返回 0）。
     */
    public static long nextLevelSeconds(long listenSeconds) {
        int level = levelOf(listenSeconds);
        if (level >= MAX_LEVEL) {
            return 0;
        }
        return THRESHOLDS[level] - Math.max(0, listenSeconds);
    }

    /**
     * 当前等级进度百分比（0~100，用于进度条展示）。
     */
    public static int progressOf(long listenSeconds) {
        int level = levelOf(listenSeconds);
        if (level >= MAX_LEVEL) {
            return 100;
        }
        long base = THRESHOLDS[level - 1];
        long next = THRESHOLDS[level];
        long span = next - base;
        if (span <= 0) {
            return 100;
        }
        long cur = Math.max(0, listenSeconds) - base;
        return (int) Math.min(100, cur * 100 / span);
    }
}
