package com.luminousmossboss.luminous.model;

/**
 * Created by Brian on 2/1/2015.
 */

public class ListItem {
    private String title;
    private String date;
    private String user;
    private int status;
    private int icon;

    // boolean to set visiblity
    private boolean isDateVisible = false;
    private boolean isUserVisible = false;
    private boolean isStatusVisible = false;

    public ListItem() {}

    public ListItem(String title, int icon) {
        this.title = title;
        this.icon = icon;
    }

    public ListItem(String title, int icon, String date, String user) {
        this.title = title;
        this.icon = icon;
        this.date = date;
        this.user = user;
        this.isDateVisible = true;
        this.isUserVisible = true;
    }

    public String getTitle() { return this.title; }

    public int getIcon() { return this.icon; }

    public String getDate() { return this.date; }

    public String getUser() { return this.user; }

    public void setTitle(String title){
        this.title = title;
    }

    public void setIcon(int icon){
        this.icon = icon;
    }

    public void setDate(String date){
        this.date = date;
    }

    public void setUser(String user){
        this.user = user;
    }

    public void setStatus(int status) {this.status = status; }

    public void setDateVisibility(Boolean visibility) { this.isDateVisible =  visibility; }

    public void setUserVisibility(Boolean visibility) { this.isUserVisible =  visibility; }

    public void setStatusVisibility(Boolean visibility) { this.isStatusVisible =  visibility; }
    
    public boolean getDateVisibility() { return this.isDateVisible; }

    public boolean getUserVisibility() { return this.isUserVisible; }

    public boolean getStatusVisibility() { return this.isStatusVisible; }
}
