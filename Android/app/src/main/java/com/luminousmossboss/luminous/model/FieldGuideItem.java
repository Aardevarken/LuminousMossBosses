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


    public FieldGuideItem (int id, Context context) {
        this.id = id;
        properties = new HashMap<String, String>();
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
        this.title = properties.get("binomial_name");
        this.icon = Uri.parse("file:///android_asset/FORBS/" + properties.get("code") + ".jpg");
    }

    public String getProperty(String property_name) {
        return properties.get(property_name);
    }

    public String[] getColumns() {
        return columns;
    }
}
