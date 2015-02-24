package com.luminousmossboss.luminous.model;

import android.net.Uri;

/**
 * Created by Brian on 2/1/2015.
 */

public class FGListItem extends ListItem{
    private String description;
    private int status;
    final private int MAXCHAR = 40;
    private boolean isStatusVisible = false;

    public FGListItem() {}

    public FGListItem(String title, Uri icon) {
        super(title, icon);
    }

    public FGListItem(String title, Uri icon, String description) {
        super(title, icon);
        this.description = shortenString(description,MAXCHAR);
    }

    public String getDescription() { return this.description; }

    public void setDescription(String description){
        this.description = shortenString(description,MAXCHAR);
    }

    public void setStatus(int status) {this.status = status; }
}
