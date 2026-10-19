package com.fenglin.springboottest.common;

import lombok.Data;

/**
 * 统一接口返回结构。前端 shayu 通过 data.message / data.data.token 读取结果。
 */
@Data
public class Result<T> {

    /** 业务状态码：200 成功，4xx 业务失败 */
    private int code;

    /** 提示信息 */
    private String message;

    /** 业务数据 */
    private T data;

    public static <T> Result<T> ok(String message) {
        return ok(message, null);
    }

    public static <T> Result<T> ok(String message, T data) {
        Result<T> r = new Result<>();
        r.code = 200;
        r.message = message;
        r.data = data;
        return r;
    }

    public static <T> Result<T> fail(int code, String message) {
        Result<T> r = new Result<>();
        r.code = code;
        r.message = message;
        r.data = null;
        return r;
    }
}
