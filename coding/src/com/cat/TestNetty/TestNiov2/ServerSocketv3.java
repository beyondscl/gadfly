package com.cat.TestNetty.TestNiov2;

/**
 * author: 牛虻.
 * time:2017/11/3 0003
 * email:pettygadfly@gmail.com
 * doc:使用nio继续改进，１．４加入，本质还是同步非阻塞，但是叫做异步非阻塞也没问题，但是本质你要明白
 * [直到１．７才是真的ａｉｏ，异步非阻塞。ａｓ*ServerSocket]
 * 核心概念介绍：
 * ｂｕｆｆｅｒ　数据交互必须使用ｂｕｆｆｅｒ和ｃｈａｎｎｌ
 * ｃｈａｎｎｌ
 * ｓｌｅｃｔ　采用ｐｏｌｌ和ｓｅｌｅｃｔ类似ｌｉｎｕｘ，但是底层是ｅｐｏｌｌ，区别在于不受句柄限制
 */
public class ServerSocketv3 {
}
