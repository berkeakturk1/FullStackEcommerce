package com.example.ecommercebackend.User;

import jakarta.persistence.*;

@Entity
@Table(name = "user_")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "user_seq")
    @SequenceGenerator(name = "user_seq", sequenceName = "user__seq", allocationSize = 1)
    private int userid;

    private String bdate;
    private String email;
    private String fname;
    private String lname;
    private String password;
    private String username;
    private boolean usertype;

    public boolean getUsertype() {
        return usertype;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setUsertype(boolean usertype) {
        this.usertype = usertype;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }

    public void setLname(String lname) {
        this.lname = lname;
    }

    public void setBdate(String bdate) {
        this.bdate = bdate;
    }




    public int getUserid() {
        return userid;
    }

    public String getEmail() {
        return email;
    }

    public boolean getUserType() {
        return usertype;
    }

    public String getFname() {
        return fname;
    }

    public String getLname() {
        return lname;
    }

    public String getBdate() {
        return bdate;
    }
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setUserType(boolean userType) { this.usertype = userType;
    }


    public int getUserId() {
        return userid;
    }
}
