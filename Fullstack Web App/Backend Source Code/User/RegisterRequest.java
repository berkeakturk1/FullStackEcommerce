package com.example.ecommercebackend.User;

public class RegisterRequest {
    private String username;
    private String email;
    private String password;
    private Boolean usertype;
    private String fname;
    private String lname;
    private String bdate;

    public void setUsertype(Boolean usertype) {
        this.usertype = usertype;
    }
// Getters and setters

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }


    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFname() {
        return fname;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }

    public String getLname() {
        return lname;
    }

    public void setLname(String lname) {
        this.lname = lname;
    }

    public String getBdate() {
        return bdate;
    }

    public void setBdate(String bdate) {
        this.bdate = bdate;
    }

    public boolean getIsSeller(){
        return usertype;
    }
}