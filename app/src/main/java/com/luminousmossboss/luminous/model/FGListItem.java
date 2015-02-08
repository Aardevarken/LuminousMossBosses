package com.luminousmossboss.luminous.model;

/**
 * Created by Brian on 2/1/2015.
 */

public class FGListItem extends ListItem{
    private String description;
    private int status;
    final private int MAXCHAR = 40;
    private boolean isStatusVisible = false;

    public FGListItem() {}

    public FGListItem(String title, int icon) {
        super(title, icon);
    }

    public FGListItem(String title, int icon, String description) {
        super(title, icon);
        this.description = shortenString(description,MAXCHAR);
    }

    public String getDescription() { return this.description; }

    public void setDescription(String description){
        this.description = shortenString(description,MAXCHAR);
    }

    public void setStatus(int status) {this.status = status; }
}
