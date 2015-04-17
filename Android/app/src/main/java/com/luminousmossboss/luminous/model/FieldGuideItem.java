package com.luminousmossboss.luminous.model;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;

import com.luminousmossboss.luminous.FieldGuideDBHandler;

import java.io.Serializable;
import java.util.HashMap;

/**
 * Created by MGarske on 4/12/2015.
 */
public class FieldGuideItem extends ListItem implements Serializable {
    int id;
    HashMap<String,String> properties;
    String[] columns;
    String growthform, code, latin_name, common_name, family, description, flowershape,
            leafshapefilter, photocredit;


    public FieldGuideItem (int id, Context context) {
        this.id = id;
        properties = new HashMap<>();
        FieldGuideDBHandler db = new FieldGuideDBHandler(context);
        SQLiteDatabase fieldGuideDB = db.getReadableDatabase();
        Cursor dbCursor = fieldGuideDB.rawQuery("select * from species where id = " + Integer.toString(id), null);
        this.columns = dbCursor.getColumnNames();
        if (dbCursor.moveToFirst()) {
            for (int i = 0; i < columns.length; i++ ) {
                if (!columns[i].equals("id")) {
                    properties.put(columns[i], dbCursor.getString(i));
                }
            }
        }
        this.title = properties.get("latin_name");
        this.icon = Uri.parse("file:///android_asset/FORBS/" + properties.get("code") + ".jpg");
    }

    public FieldGuideItem(int id, String growthform, String code, String latin_name, String common_name,
                          String family, String description, String flowershape,
                          String leafshapefilter, String photocredit) {
        this.id = id;
        String[] arr = {"growthform", "code", "latin_name", "common_name", "family", "description",
                    "flowershape", "leafshapefilter", "photocredit"};
        columns = arr;
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
        return properties.keySet().toArray(new String[properties.keySet().size()]);
    }
}
