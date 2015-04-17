package com.luminousmossboss.luminous;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import com.luminousmossboss.luminous.model.FieldGuideItem;
import com.luminousmossboss.luminous.model.ListItem;
import com.readystatesoftware.sqliteasset.SQLiteAssetHelper;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by MGarske on 4/9/2015.
 */
public class FieldGuideDBHandler extends SQLiteAssetHelper {

    private static final String DATABASE_NAME = "fieldguide.db";
    private static final int DATABASE_VERSION = 1;
    private static List<Integer> ids;
    private static HashMap<Integer, String> iconPaths;
    private static HashMap<Integer, String> latinNames;
    private static HashMap<Integer, String> commonNames;
    private static HashMap<Integer, FieldGuideItem> fgItemCache;
    private static FieldGuideDBHandler instance;

    private FieldGuideDBHandler(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        ids = new ArrayList<>();
        fgItemCache = new HashMap<>();
        iconPaths = new HashMap<>();
        latinNames = new HashMap<>();
        commonNames = new HashMap<>();
    }

    public static FieldGuideDBHandler getInstance(Context context) {
        if (instance == null) {
            instance = new FieldGuideDBHandler(context);
        }
        return instance;
    }

    public List<Integer> getIDs() {
        if (ids.isEmpty()) {
            SQLiteDatabase db = this.getReadableDatabase();
            Cursor cursor = db.rawQuery("select id, code, latin_name, common_name " +
                    "from species order by latin_name;", null);
            if (cursor.moveToFirst()){
                do {
                    int id = cursor.getInt(0);
                    ids.add(id);
                    iconPaths.put(id, "file:///android_asset/FORBS/" + cursor.getString(1) + ".jpg");
                    latinNames.put(id, cursor.getString(2));
                    commonNames.put(id, cursor.getString(3));
                } while (cursor.moveToNext());
            }
            cursor.close();
            db.close();
        }
        return ids;
    }

    public HashMap<Integer, String> getIconPaths() {
        if (ids.isEmpty())
        {
            this.getIDs();
        }
        return iconPaths;
    }

    public HashMap<Integer, String> getLatinNames() {
        if (ids.isEmpty())
        {
            this.getIDs();
        }
        return latinNames;
    }

    public HashMap<Integer, String> getCommonNames() {
        if (ids.isEmpty())
        {
            this.getIDs();
        }
        return commonNames;
    }

    private List<String> listFromCursor (Cursor cursor) {
        List<String> list = new ArrayList<>();
        if (cursor.moveToFirst()) {
            do {
                list.add(cursor.getString(0));
            } while (cursor.moveToNext());
        }
        return list;
    }

    private List<String> getSynonyms(int id) {
        List<String> synonyms;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("select synonym.name from species " +
                "join synonym on species_id = species.id " +
                "where species.id = " + Integer.toString(id), null);
        synonyms = listFromCursor(cursor);
        cursor.close();
        db.close();
        return synonyms;
    }

    private List<String> getFlowerColors(int id) {
        List<String> flowercolors;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("select flowercolor.name from species " +
                "join species_flowercolor on species.id = species_id " +
                "join flowercolor on flowercolor.id = flowercolor_id " +
                "where species.id = " + Integer.toString(id), null);
        flowercolors = listFromCursor(cursor);
        cursor.close();
        db.close();
        return flowercolors;
    }

    private List<String> getPetalNumbers(int id) {
        List<String> petalnumbers;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("select petalnumber.name from species " +
                "join species_petalnumber on species.id = species_id " +
                "join petalnumber on petalnumber.id = petalnumber_id " +
                "where species.id = " + Integer.toString(id), null);
        petalnumbers = listFromCursor(cursor);
        cursor.close();
        db.close();
        return petalnumbers;
    }

    private List<String> getInflorescence(int id) {
        List<String> inflorescence;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("select inflorescence.name from species " +
                "join species_inflorescence on species.id = species_id " +
                "join inflorescence on inflorescence.id = inflorescence_id " +
                "where species.id = " + Integer.toString(id), null);
        inflorescence = listFromCursor(cursor);
        cursor.close();
        db.close();
        return inflorescence;
    }

    private List<String> getLeafArrangements(int id) {
        List<String> leafarrangements;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("select leafarrangement.name from species " +
                "join species_leafarrangement on species.id = species_id " +
                "join leafarrangement on leafarrangement.id = leafarrangement_id " +
                "where species.id = " + Integer.toString(id), null);
        leafarrangements = listFromCursor(cursor);
        cursor.close();
        db.close();
        return leafarrangements;
    }

    private List<String> getLeafShapes(int id) {
        List<String> leafshapes;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("select leafshape.name from species " +
                "join species_leafshape on species.id = species_id " +
                "join leafshape on leafshape.id = leafshape_id " +
                "where species.id = " + Integer.toString(id), null);
        leafshapes = listFromCursor(cursor);
        cursor.close();
        db.close();
        return leafshapes;
    }

    private List<String> getHabitats(int id) {
        List<String> habitats;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("select habitat.name from species " +
                "join species_habitat on species.id = species_id " +
                "join habitat on habitat.id = habitat_id " +
                "where species.id = " + Integer.toString(id), null);
        habitats = listFromCursor(cursor);
        cursor.close();
        db.close();
        return habitats;
    }

    private List<String> getCFs(int id) {
        List<String> cfs;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("select cf.name from species " +
                "join cf on species_id = species.id " +
                "where species.id = " + Integer.toString(id), null);
        cfs = listFromCursor(cursor);
        cursor.close();
        db.close();
        return cfs;
    }

    public FieldGuideItem getFGItemWithID(int id) {
        if (fgItemCache.containsKey(id)) {
            return fgItemCache.get(id);
        }
        String growthform, code, latin_name, common_name, family, description, flowershape,
                leafshapefilter, photocredit;
        List<String> synonyms = getSynonyms(id);
        List<String> flowercolors = getFlowerColors(id);
        List<String> petalnumbers = getPetalNumbers(id);
        List<String> inflorescence = getInflorescence(id);
        List<String> leafarrangments = getLeafArrangements(id);
        List<String> leafshapes = getLeafShapes(id);
        List<String> habitats = getHabitats(id);
        List<String> cfs = getCFs(id);

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
        FieldGuideItem item =  new FieldGuideItem(id, growthform, code, latin_name, common_name, family, description,
                flowershape, leafshapefilter, photocredit, synonyms, flowercolors, petalnumbers,
                inflorescence, leafarrangments, leafshapes, habitats, cfs);
        fgItemCache.put(id, item);
        return item;
    }


}