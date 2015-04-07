package com.luminousmossboss.luminous.model;

import java.io.Serializable;

/**
 * Created by Brian on 4/5/2015.
 */

public class DataItem extends ListItem implements Serializable {

    private String description;

    public DataItem() {}

    public DataItem(String title, String description) {
        setTitle(title);
        setDescription(description);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
