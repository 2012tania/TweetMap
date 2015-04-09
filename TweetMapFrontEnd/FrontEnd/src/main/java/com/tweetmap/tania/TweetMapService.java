package com.tweetmap.tania;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import java.sql.*;

@Path("/tweet")
public class TweetMapService {

    @GET
    @Produces("application/json")
    public Tweet[] getAllTweets(){

        System.out.println("MySQL JDBC Driver Registered!");

        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return null;
        }

        try {
            Connection conn = DriverManager
                    .getConnection("jdbc:mysql://tweetdb.cqdvxnqn5gyd.us-east-1.rds.amazonaws.com:3306/TweetDB",
                            "tweetdb", "tweetdb123");
            Statement stmt1 = conn.createStatement();
            String query = new String("SELECT * FROM tweet_table;");
            ResultSet rs = stmt1.executeQuery(query);
            int count = 0;
            while(rs.next())
                count++;
            Tweet[] tweet = new Tweet[count];
            rs.first();
            for(int i=0;i<count;i++)
            {
                tweet[i] = new Tweet(rs.getLong(1),rs.getString(3),rs.getString(2),rs.getDouble(4),rs.getDouble(5));
                rs.next();
            }
            conn.close();
            return tweet;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @GET
    @Path("/getHashTag/{hash}")
    @Produces("application/json")
    public Tweet[] getHashTweets(@PathParam("hash") String hashTag) {

        System.out.println("MySQL JDBC Driver Registered!");
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return null;
        }

        try {
            Connection conn = DriverManager
                    .getConnection("jdbc:mysql://tweetdb.cqdvxnqn5gyd.us-east-1.rds.amazonaws.com:3306/TweetDB",
                            "tweetdb", "tweetdb123");
            Statement stmt1 = conn.createStatement();
            String query = new String("SELECT * FROM tweet_table WHERE tweetText LIKE '%#" + hashTag +"%' ;");
            ResultSet rs = stmt1.executeQuery(query);
            int count = 0;
            while(rs.next())
                count++;
            Tweet[] tweet = new Tweet[count];
            rs.first();
            for(int i=0;i<count;i++)
            {
                tweet[i] = new Tweet(rs.getLong(1),rs.getString(3),rs.getString(2),rs.getDouble(4),rs.getDouble(5));
                rs.next();
            }
            conn.close();
            return tweet;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }


    public class Tweet{
        long tweetId;
        String userScreenName;
        String text;
        double latitude,longitude;

        public Tweet(long tid, String content, String userScreenName, double lat, double lon){
            tweetId = tid;
            text = content;
            latitude = lat;
            this.userScreenName = userScreenName;
            longitude = lon;
        }
    }
}
