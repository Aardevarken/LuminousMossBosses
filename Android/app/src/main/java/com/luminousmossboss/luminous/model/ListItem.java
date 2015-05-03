package com.luminousmossboss.luminous.model;

import android.net.Uri;

/**
 * Created by Brian on 2/1/2015.
 */

abstract public class ListItem {
    protected String title;
    protected Uri icon;

    public ListItem() {}

    public ListItem(String title, Uri icon) {
        this.title = title;
        this.icon = icon;
    }

    public String getTitle() { return this.title; }

    public Uri getIcon() { return this.icon; }

    public void setTitle(String title){
        this.title = title;
    }

    public void setIcon(Uri icon){
        this.icon = icon;
    }

    public String shortenString(String string, int amount) {
        return string.substring(0, Math.min(string.length(), amount))+"...";
    }

}
