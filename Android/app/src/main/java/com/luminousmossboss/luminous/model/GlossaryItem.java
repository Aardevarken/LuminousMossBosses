package com.luminousmossboss.luminous.model;

import android.net.Uri;
import android.text.TextUtils;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;

/**
 * Created by MGarske on 4/12/2015.
 */
public class GlossaryItem extends ListItem implements Serializable {
    int id;
    String category;

    public GlossaryItem(int id, String title, String category) {
        this.id = id;
        this.title = title;
        this.icon = Uri.parse(title+".jpeg");
        this.category = category;
    }

    public int getId() {
        return id;
    }

    public String getCategory() {
        return category;
    }

}
