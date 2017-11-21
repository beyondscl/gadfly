package com.learn.test;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * author: 牛虻.
 * time:2017/11/21
 * email:pettygadfly@gmail.com
 * doc:
 */
public class jdbctest {

    public static void main(String[] args) throws Exception {
        Connection conn = null;
        Statement statement = null;
        ResultSet rs = null;
        try {
            String url = "jdbc:mysql://127.0.0.1:3306/world";
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, "root", "mysql");
            statement = conn.createStatement();
            statement.execute("select * from world.user ");
            rs = statement.getResultSet();
            System.out.println(rs);
            while (rs.next()) {
                System.out.println(rs.getString(1));
                System.out.println(rs.getString(2));
                System.out.println(rs.getInt(3));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            rs.close();
            statement.close();
            conn.close();
        }
    }
}
