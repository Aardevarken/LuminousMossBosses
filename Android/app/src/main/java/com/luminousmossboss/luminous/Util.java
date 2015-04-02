package com.luminousmossboss.luminous;

import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Log;
import android.widget.ImageView;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
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
    public static boolean detectImage(String image_path, Context context) {
        File flowerXML = rawToFile(R.raw.flower, context);
        File vocabXML = rawToFile(R.raw.vocabulary, context);
        File sileneXML = rawToFile(R.raw.silene, context);
        // create the detector
        SileneDetector sileneDetector = new SileneDetector(flowerXML.getAbsolutePath(),
                vocabXML.getAbsolutePath(),
                sileneXML.getAbsolutePath());
        // run the detection
        return sileneDetector.isSilene(image_path);
    }
    // creates new file from a raw resource in the file_resources folder
    // Adapted from Eduardo's answer at stackoverflow.com/questions/17189214
    private static File rawToFile (int resId,Context context)
    {
        InputStream is = context.getResources().openRawResource(resId);
        File dir = context.getDir("file_resources", Context.MODE_PRIVATE);
        File file = new File(dir, Integer.toString(resId));
        try
        {
            FileOutputStream os = new FileOutputStream(file);

            byte[] buff = new byte[4096];
            int bytesRead;
            while ((bytesRead = is.read(buff)) != -1)
            {
                os.write(buff, 0, bytesRead);
            }
            is.close();
            os.close();
        }
        catch (IOException e)
        {
            e.printStackTrace();
            Log.v("MainActivity", "Failed to load silene classifier. Exception thrown: " + e);
        }
        return file;
    }


}
