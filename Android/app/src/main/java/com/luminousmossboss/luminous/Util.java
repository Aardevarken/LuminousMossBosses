package com.luminousmossboss.luminous;

import android.content.Context;
import android.net.Uri;

/**
 * Created by andrey on 2/24/15.
 */
public class Util {
    public static final String ANDROID_RESOURCE = "android.resource://";
    public static final String FORESLASH = "/";


    public static Uri resIdToUri(Context context, int resId) {
        return Uri.parse(ANDROID_RESOURCE + context.getPackageName()
                + FORESLASH + resId);
    }
}
