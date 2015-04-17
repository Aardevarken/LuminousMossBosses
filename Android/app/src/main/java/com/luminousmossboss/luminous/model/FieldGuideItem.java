package com.luminousmossboss.luminous.model;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;

import com.luminousmossboss.luminous.FieldGuideDBHandler;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;

/**
 * Created by MGarske on 4/12/2015.
 */
public class FieldGuideItem extends ListItem implements Serializable {
    int id;
    HashMap<String,String> properties;
    String[] columns;

    public FieldGuideItem(int id, String title, String iconPath, String common_name) {
        this.id = id;
        this.title = title;
        this.icon = Uri.parse(iconPath);
        properties = new HashMap<>();
        properties.put("common_name", common_name);
    }

    public FieldGuideItem(int id, String growthform, String code, String latin_name, String common_name,
                          String family, String description, String flowershape,
                          String leafshapefilter, String photocredit, List<String> synonyms,
                          List<String> flowercolors, List<String> petalnumbers,
                          List<String> inflorescence, List<String> leafarrangments,
                          List<String> leafshapes, List<String> habitats, List<String> cfs) {
        this.id = id;
        String[] order = {"growthform", "code", "latin_name", "common_name", "family", "description",
                    "flowershape", "leafshapefilter", "photocredit"};
        columns = order;
        properties = new HashMap<>();
        properties.put("growthform", growthform);
        properties.put("code", code);
        properties.put("latin_name", latin_name);
        properties.put("common_name", common_name);
        properties.put("family", family);
        properties.put("description", description);
        properties.put("flowershape", flowershape);
        properties.put("leafshapefilter", leafshapefilter);
        properties.put("photocredit", photocredit);
        this.title = properties.get("latin_name");
        this.icon = Uri.parse("file:///android_asset/FORBS/" + properties.get("code") + ".jpg");
    }

    public String getProperty(String property_name) {
        return properties.get(property_name);
    }

    public String[] getColumns() {
        return columns;
    }

    public int getId() {
        return id;
    }

}
