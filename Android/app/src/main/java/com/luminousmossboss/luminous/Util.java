package com.luminousmossboss.luminous;

import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.provider.MediaStore;
import android.widget.ImageView;

import java.io.File;
import java.io.FileInputStream;
import java.net.URI;

/**
 * Created by andrey on 2/24/15.
 */
public class Util {
    public static final String ANDROID_RESOURCE = "android.resource://";
    public static final String FORESLASH = "/";
    final static int THUMBNAIL_SIZE = 75;


    public static Uri resIdToUri(Context context, int resId) {
        return Uri.parse(ANDROID_RESOURCE + context.getPackageName()
                + FORESLASH + resId);
    }

    public static Bitmap getPreview(Uri uri, Context context) {

        String path = null;
        String[] projection = { MediaStore.Images.Media.DATA };
        Cursor cursor = context.getContentResolver().query(uri, projection, null, null, null);
        if (cursor.moveToFirst()) {
            int columnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            path = cursor.getString(columnIndex);
        }
        cursor.close();
        File fileName = new File(path);
        try
        {
            FileInputStream fis = new FileInputStream(fileName);
            Bitmap imageBitmap = BitmapFactory.decodeStream(fis);

            imageBitmap = Bitmap.createScaledBitmap(imageBitmap, THUMBNAIL_SIZE, THUMBNAIL_SIZE, false);
            return imageBitmap;

        }
        catch(Exception ex) {
            return null;

        }

    }

}
