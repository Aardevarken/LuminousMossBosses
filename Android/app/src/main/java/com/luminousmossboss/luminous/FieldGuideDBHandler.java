package com.luminousmossboss.luminous;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.luminousmossboss.luminous.model.FieldGuideItem;
import com.luminousmossboss.luminous.model.ListItem;
import com.readystatesoftware.sqliteasset.SQLiteAssetHelper;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by MGarske on 4/9/2015.
 */
public class FieldGuideDBHandler extends SQLiteAssetHelper {

    private static final String DATABASE_NAME = "fieldguide.db";
    private static final int DATABASE_VERSION = 1;
    private List<Integer> ids;

    public FieldGuideDBHandler(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        ids = new ArrayList<>();
    }


    public List<Integer> getIDs() {
        if (ids.isEmpty()) {
            SQLiteDatabase db = this.getReadableDatabase();
            Cursor cursor = db.rawQuery("select id from species order by latin_name;", null);
            if (cursor.moveToFirst()){
                do {
                    ids.add(cursor.getInt(0));
                } while (cursor.moveToNext());
            }
            cursor.close();
            db.close();
        }
        return ids;
    }

    private List<String> getSynonyms(int id) {
        return  new ArrayList<>();
    }

    private List<String> getFlowerColors(int id) {
        List<String> flowercolors = new ArrayList<>();
        return flowercolors;
    }

    private List<String> getPetalNumbers(int id) {
        return  new ArrayList<>();
    }

    private List<String> getInflorescence(int id) {
        return  new ArrayList<>();
    }

    private List<String> getLeafArrangements(int id) {
        return  new ArrayList<>();
    }

    private List<String> getLeafShapes(int id) {
        return  new ArrayList<>();
    }

    private List<String> getHabitats(int id) {
        return  new ArrayList<>();
    }

    private List<String> getCFs(int id) {
        return  new ArrayList<>();
    }

    public FieldGuideItem getFGItemWithID(int id) {
        String growthform, code, latin_name, common_name, family, description, flowershape,
                leafshapefilter, photocredit;
        List<String> synonyms = new ArrayList<>();
        List<String> flowercolors = new ArrayList<>();
        List<String> petalnumbers = new ArrayList<>();
        List<String> inflorescence = new ArrayList<>();
        List<String> leafarrangments = new ArrayList<>();
        List<String> leafshapes = new ArrayList<>();
        List<String> habitats = new ArrayList<>();
        List<String> cfs = new ArrayList<>();

        growthform = code = latin_name = common_name = family = description = flowershape =
                leafshapefilter = photocredit = "";

        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("select growthform.name, code, latin_name, " +
                "common_name, family, description, flowershape.name, " +
                "leafshapefilter.name, photocredit from species " +
                "join growthform on growthform_id = growthform.id " +
                "join flowershape on flowershape.id = flowershape_id " +
                "join leafshapefilter on leafshapefilter_id = leafshapefilter.id " +
                "where species.id = " + Integer.toString(id), null);
        if (cursor.moveToFirst()) {
            growthform = cursor.getString(0);
            code = cursor.getString(1);
            latin_name = cursor.getString(2);
            common_name = cursor.getString(3);
            family = cursor.getString(4);
            description = cursor.getString(5);
            flowershape = cursor.getString(6);
            leafshapefilter = cursor.getString(7);
            photocredit = cursor.getString(8);
        }

        cursor.close();
        db.close();
        return new FieldGuideItem(id, growthform, code, latin_name, common_name, family, description,
                flowershape, leafshapefilter, photocredit);
    }


}