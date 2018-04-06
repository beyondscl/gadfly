package com.snake.smartc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Vector;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.locks.ReentrantLock;

/**
 * author: 牛虻.
 * time:2018/4/6
 * email:pettygadfly@gmail.com
 * doc:
 */
public class GadPool implements Pool {
    static {
        try {
            Class.forName(Config.driver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    private volatile AtomicInteger count= new AtomicInteger(0);
    private ReentrantLock lock = new ReentrantLock();

    private Vector<Connection> vectorConns = null;

    @Override
    public void registerDriver() throws ClassNotFoundException {

    }

    @Override
    public void initPool(int min, int max) throws SQLException {
        synchronized (this){
            if (min <= 0 || max > Integer.MAX_VALUE)
                throw new RuntimeException("init number error");
            vectorConns = new Vector<>(max);
            for (int i = 0; i < min; i++) {
                Connection conn = DriverManager.getConnection(Config.url, Config.uname, Config.upass);
                vectorConns.add(conn);
                count.incrementAndGet();
            }
        }
    }

    @Override
    public Connection getConnect() {
        return this.vectorConns.firstElement();
    }

    @Override
    public Connection closeConnect(Connection conn) {
        return null;
    }

    @Override
    public Connection releaseConnect(Connection conn) {
        return null;
    }

    @Override
    public void releasePoll() throws SQLException {
        while (this.vectorConns.elements().hasMoreElements()){
            Connection conn = this.vectorConns.elements().nextElement();
            conn.close();
            this.vectorConns.remove(conn);
        }
    }
}
