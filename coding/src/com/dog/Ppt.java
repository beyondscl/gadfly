package com.dog;

/**
 * Created by Administrator on 2017/3/18 0018.
 */
public class Ppt {

    //1直接new 具体对象
//    FastSot fastSot = new FastSot();

    //2使用接口，直接new 接口的子类
//    FastSotF fastSotF = new fastSot();

    //3配置接口，采用set方法运行时设置值
    FastSotF fastSotF;
    public FastSotF getFastSotF() {
        return fastSotF;
    }
    public void setFastSotF(FastSotF fastSotF) {
        this.fastSotF = fastSotF;
    }
}
