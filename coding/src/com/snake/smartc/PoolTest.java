package com.snake.smartc;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * author: 牛虻.
 * time:2018/4/6
 * email:pettygadfly@gmail.com
 * doc:
 */
public class PoolTest{
    private static GadPool gadPool = new GadPool();
    @Test

    public void registerDriver() throws ClassNotFoundException {
        gadPool.registerDriver();
    }

    @Before
    public void initPool() throws SQLException {
        gadPool.initPool(1,9);
    }

    @Test
    public void getConnect() {
        System.out.println(gadPool.getConnect());
    }


    public Connection closeConnect(Connection conn) {
        return null;
    }


    public Connection releaseConnect(Connection conn) {
        return null;
    }

    @After
    public void releasePollss() throws SQLException {
        gadPool.releasePoll();
    }
}
