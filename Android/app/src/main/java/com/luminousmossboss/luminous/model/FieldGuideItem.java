package com.luminousmossboss.luminous.model;

import android.net.Uri;
import android.text.TextUtils;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;

/**
 * Created by MGarske on 4/12/2015.
 */
public class FieldGuideItem extends ListItem implements Serializable {
    int id;
    HashMap<String,String> properties;

    // Names of keys for properties
    public static final String GROWTH_FORM = "Growth Form";
    public static final String CODE = "code";
    public static final String LATIN_NAME = "Latin Name";
    public static final String COMMON_NAME = "Common Name";
    public static final String FAMILY = "Family";
    public static final String SYNONYMS = "Synonyms";
    public static final String DESCRIPTION = "Description";
    public static final String FLOWER_COLOR = "Flower Color";
    public static final String FLOWER_SHAPE = "Flower Shape";
    public static final String PETAL_NUMBER = "Petal Number";
    public static final String INFLORESCENCE = "Inflorescence";
    public static final String LEAF_ARRANGEMENT = "Leaf Arrangement";
    public static final String LEAF_SHAPE = "Leaf Shape";
    public static final String LEAF_SHAPE_FILTER = "Leaf Shape Filter";
    public static final String HABITAT = "Habitat";
    public static final String CF = "c.f.";
    public static final String PHOTO_CREDIT = "Photo Credit";

    static final String[] displayColumns =
            {DESCRIPTION, COMMON_NAME, FAMILY, GROWTH_FORM, SYNONYMS, FLOWER_COLOR, FLOWER_SHAPE,
             PETAL_NUMBER, INFLORESCENCE, LEAF_ARRANGEMENT, LEAF_SHAPE, HABITAT, CF, PHOTO_CREDIT};


    public FieldGuideItem(int id, String title, String iconPath, String common_name) {
        this.id = id;
        this.title = title;
        this.icon = Uri.parse(iconPath);
        properties = new HashMap<>();
        properties.put("common_name", common_name);
    }

    public FieldGuideItem(int id, String growthform, String code, String latin_name, String common_name,
                          String family, String description, String flowershape,
                          String leafshapefilter, String photocredit, List<String> synonyms,
                          List<String> flowercolors, List<String> petalnumbers,
                          List<String> inflorescence, List<String> leafarrangments,
                          List<String> leafshapes, List<String> habitats, List<String> cfs) {
        this.id = id;
        properties = new HashMap<>();
        properties.put(GROWTH_FORM, growthform);
        properties.put(CODE, code);
        properties.put(LATIN_NAME, latin_name);
        properties.put(COMMON_NAME, common_name);
        properties.put(FAMILY, family);
        properties.put(SYNONYMS, TextUtils.join("\n", synonyms));
        properties.put(DESCRIPTION, description);
        properties.put(FLOWER_COLOR, TextUtils.join("\n", flowercolors));
        properties.put(FLOWER_SHAPE, flowershape);
        properties.put(PETAL_NUMBER, TextUtils.join("\n", petalnumbers));
        properties.put(INFLORESCENCE, TextUtils.join("\n", inflorescence));
        properties.put(LEAF_ARRANGEMENT, TextUtils.join("\n", leafarrangments));
        properties.put(LEAF_SHAPE, TextUtils.join("\n", leafshapes));
        properties.put(LEAF_SHAPE_FILTER, leafshapefilter);
        properties.put(HABITAT, TextUtils.join("\n", habitats));
        properties.put(CF, TextUtils.join("\n", cfs));
        properties.put(PHOTO_CREDIT, photocredit);
        this.title = latin_name;
        this.icon = Uri.parse("file:///android_asset/FORBS/" + code + ".jpg");
    }

    public String getProperty(String property_name) {
        return properties.get(property_name);
    }

    public String[] getDisplayColumns() {
        return displayColumns;
    }

    public int getId() {
        return id;
    }

}
