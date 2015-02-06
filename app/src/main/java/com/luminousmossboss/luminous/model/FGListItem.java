package com.luminousmossboss.luminous.model;

/**
 * Created by Brian on 2/1/2015.
 */

public class FGListItem extends ListItem{
    private String description;
    private String user;
    private int status;

    private boolean isStatusVisible = false;

    public FGListItem() {}

    public FGListItem(String title, int icon) {
        super(title, icon);
    }

    public FGListItem(String title, int icon, String date, String user) {
        super(title, icon);
        this.description = date;
        this.user = user;
    }

    public String getDate() { return this.description; }

    public String getUser() { return this.user; }

    public void setDate(String date){
        this.description = date;
    }

    public void setUser(String user){
        this.user = user;
    }

    public void setStatus(int status) {this.status = status; }
}
