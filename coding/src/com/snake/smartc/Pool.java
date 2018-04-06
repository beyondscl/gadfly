package com.snake.smartc;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * author: 牛虻.
 * time:2018/4/6
 * email:pettygadfly@gmail.com
 * doc:
 */
public interface Pool {
    //请用自己实现的数据结构存储
    void registerDriver() throws ClassNotFoundException;

    void initPool(int min, int max) throws SQLException;

    Connection getConnect();//获取链接

    Connection closeConnect(Connection conn);//返回链接

    Connection releaseConnect(Connection conn);//真的关闭

    void releasePoll() throws SQLException;//真的关闭
}
