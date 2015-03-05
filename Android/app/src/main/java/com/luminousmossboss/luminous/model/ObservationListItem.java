package com.luminousmossboss.luminous.model;

import android.net.Uri;

import java.io.Serializable;

/**
 * Created by Brian on 2/1/2015.
 */

public class ObservationListItem extends ListItem implements Serializable {
    private String date;
    private int status;
    final private int MAXCHAR = 10;
    private boolean isStatusVisible = false;

    public ObservationListItem() {}

    public ObservationListItem(String title, Uri icon) {
        super(title, icon);
    }

    public ObservationListItem(String title, Uri icon, String date) {
        super(title, icon);
        this.date = shortenString(date,MAXCHAR);
    }

    public String getDate() { return this.date; }

    public void setDate(String date){
        this.date = shortenString(date,MAXCHAR);
    }

    public void setStatus(int status) {this.status = status; }
}
