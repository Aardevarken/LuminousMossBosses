package com.luminousmossboss.luminous.model;

import android.net.Uri;

/**
 * Created by Brian on 2/1/2015.
 */

public class ObservationListItem extends ListItem{
    private String date;
    private int status;
    final private int MAXCHAR = 40;
    private boolean isStatusVisible = false;

    public ObservationListItem() {}

    public ObservationListItem(String title, Uri icon) {
        super(title, icon);
    }

    public ObservationListItem(String title, Uri icon, String description) {
        super(title, icon);
        this.date = shortenString(description,MAXCHAR);
    }

    public String getDate() { return this.date; }

    public void setDate(String date){
        this.date = shortenString(date,MAXCHAR);
    }

    public void setStatus(int status) {this.status = status; }
}
