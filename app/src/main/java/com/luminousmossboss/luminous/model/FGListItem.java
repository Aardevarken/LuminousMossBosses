package com.luminousmossboss.luminous.model;

/**
 * Created by Brian on 2/1/2015.
 */

public class FGListItem extends ListItem{
    private String date;
    private String user;
    private int status;

    // boolean to set visiblity
    private boolean isDateVisible = false;
    private boolean isUserVisible = false;
    private boolean isStatusVisible = false;

    public FGListItem() {}

    public FGListItem(String title, int icon) {
        super(title, icon);
    }

    public FGListItem(String title, int icon, String date, String user) {
        super(title, icon);
        this.date = date;
        this.user = user;
        this.isDateVisible = true;
        this.isUserVisible = true;
    }

    public String getDate() { return this.date; }

    public String getUser() { return this.user; }

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
