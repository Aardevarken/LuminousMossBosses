package com.luminousmossboss.luminous;

import android.content.Context;

import com.readystatesoftware.sqliteasset.SQLiteAssetHelper;

/**
 * Created by MGarske on 4/9/2015.
 */
public class FieldGuideDBHandler extends SQLiteAssetHelper {

    private static final String DATABASE_NAME = "fieldguide.db";
    private static final int DATABASE_VERSION = 1;

    public FieldGuideDBHandler(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
}