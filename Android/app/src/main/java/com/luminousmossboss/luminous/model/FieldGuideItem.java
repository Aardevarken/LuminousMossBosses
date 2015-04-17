package com.luminousmossboss.luminous.model;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;
import android.text.TextUtils;

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
        String[] order = {"Growth Form", "code", "Latin Name", "Common Name", "Family", "Synonyms",
                "Description", "Flower Color", "Flower Shape", "Petal Number", "Inflorescence",
                "Leaf Arrangement", "Leaf Shape", "Leaf Shape Filter", "Habitat", "c.f.", "Photo Credit"};
        columns = order;
        properties = new HashMap<>();
        properties.put(columns[0], growthform);
        properties.put(columns[1], code);
        properties.put(columns[2], latin_name);
        properties.put(columns[3], common_name);
        properties.put(columns[4], family);
        properties.put(columns[5], TextUtils.join("\n", synonyms));
        properties.put(columns[6], description);
        properties.put(columns[7], TextUtils.join("\n", flowercolors));
        properties.put(columns[8], flowershape);
        properties.put(columns[9], TextUtils.join("\n", petalnumbers));
        properties.put(columns[10], TextUtils.join("\n", inflorescence));
        properties.put(columns[11], TextUtils.join("\n", leafarrangments));
        properties.put(columns[12], TextUtils.join("\n", leafshapes));
        properties.put(columns[13], leafshapefilter);
        properties.put(columns[14], TextUtils.join("\n", habitats));
        properties.put(columns[15], TextUtils.join("\n", cfs));
        properties.put(columns[16], photocredit);
        this.title = latin_name;
        this.icon = Uri.parse("file:///android_asset/FORBS/" + code + ".jpg");
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
