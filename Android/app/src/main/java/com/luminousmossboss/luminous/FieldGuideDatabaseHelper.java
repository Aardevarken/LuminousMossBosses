package com.luminousmossboss.luminous;

import android.content.Context;

import com.readystatesoftware.sqliteasset.SQLiteAssetHelper;

/**
 * Created by MGarske on 4/9/2015.
 */
public class FieldGuideDatabaseHelper extends SQLiteAssetHelper {

    private static final String DATABASE_NAME = "fieldguide.db";
    private static final int DATABASE_VERSION = 1;

    public FieldGuideDatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
}