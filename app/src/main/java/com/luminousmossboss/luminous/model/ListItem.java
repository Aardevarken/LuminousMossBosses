package com.luminousmossboss.luminous.model;

/**
 * Created by Brian on 2/1/2015.
 */

abstract public class ListItem {
    private String title;
    private int icon;

    public ListItem() {}

    public ListItem(String title, int icon) {
        this.title = title;
        this.icon = icon;
    }

    public String getTitle() { return this.title; }

    public int getIcon() { return this.icon; }

    public void setTitle(String title){
        this.title = title;
    }

    public void setIcon(int icon){
        this.icon = icon;
    }

    public String shortenString(String string, int amount) {
        return string.substring(0, Math.min(string.length(), amount))+"...";
    }

}
