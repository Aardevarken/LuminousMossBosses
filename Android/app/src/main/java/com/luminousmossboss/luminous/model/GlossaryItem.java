package com.luminousmossboss.luminous.model;

import android.content.ContentResolver;
import android.content.Context;
import android.content.res.AssetManager;
import android.content.res.Resources;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.text.TextUtils;
import com.luminousmossboss.luminous.R;
import java.io.File;
import java.io.InputStream;
import java.io.Serializable;
import java.util.HashMap;
import java.util.List;

/**
 * Created by MGarske on 4/12/2015.
 */
public class GlossaryItem extends ListItem implements Serializable {
    String category;
    static HashMap<String, GlossaryItem> cachedItems;

    private GlossaryItem(String title, String category, Context context) {

        this.title = title;
        this.category = category;
        String resource = "file:///android_asset/GlossaryImages/" + title+".jpeg";
        String asset = "GlossaryImages/" + title+".jpeg";
        if (assetExists(asset, context))
            this.icon = Uri.parse(resource);
        else
            this.icon = null;
    }

    public static GlossaryItem getGlossaryItem(String title, String category, Context context)
    {
        if (cachedItems == null)
            cachedItems = new HashMap<>();
        String key = title + category;
        if (cachedItems.containsKey(key)) {
            return cachedItems.get(key);
        }
        else{
            GlossaryItem item = new GlossaryItem(title, category, context);
            cachedItems.put(key, item);
            return item;
        }
    }



    private boolean assetExists(String assetString, Context context) {
        AssetManager am = context.getAssets();
        try {
            am.open(assetString);
        }
        catch (java.io.IOException e)
        {
            return false;
        }
        return true;
    }

    public String getCategory() {
        return category;
    }

    public static void clearCache() {
        cachedItems = null;
    }
}
