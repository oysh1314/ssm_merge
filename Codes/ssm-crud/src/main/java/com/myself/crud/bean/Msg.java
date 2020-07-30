package com.myself.crud.bean;

import com.github.pagehelper.PageInfo;

import java.util.HashMap;
import java.util.Map;

/**
 * @author lzq
 * @create 2020-07-28 21:29
 *
 * 通用的返回类
 *   封装了要返回给用户的数据，同时还扩充了一些内容！最终需要解析的就是这个新的返回的msg对象类型！
 *   装饰者模式！？还是包装类而已？！
 */
public class Msg {
    // 状态码：100-成功，200-失败
    private int code;
    // 提示信息
    private String msg;
    // 用户要返回给浏览器的数据
    private Map<String,Object> extend = new HashMap<>();

    // 成功
    public static Msg success(){
        Msg result = new Msg();
        result.setCode(100);
        result.setMsg("处理成功！");
        return result;
    }

    // 失败
    public static Msg fail(){
        Msg result = new Msg();
        result.setCode(200);
        result.setMsg("处理失败！");
        return result;
    }

    // 处理用户自定义的key与value
    public Msg add(String key, Object value) {
        this.getExtend().put(key,value);
        return this;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Map<String, Object> getExtend() {
        return extend;
    }

    public void setExtend(Map<String, Object> extend) {
        this.extend = extend;
    }
}
