package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.res.TypedArray;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import com.luminousmossboss.luminous.adapter.FGListAdapter;
import com.luminousmossboss.luminous.model.FGListItem;
import com.luminousmossboss.luminous.model.ListItem;

import java.util.ArrayList;

/**
 *
 * Created by Brian on 2/1/2015.
 */

public class FieldGuideListFragment extends Fragment implements BackButtonInterface{

    private Context context;
    private String mTitle;

    private ListView mDrawerList;

    private FGListAdapter adapter;
    private ArrayList<ListItem> listItems;

    public FieldGuideListFragment(){}

    @Override
    public Boolean allowedBackPressed() {
        return true;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_listview, container, false);

        initList(rootView, container);

        final Activity activity = getActivity();

        this.mDrawerList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if(activity instanceof MainActivity) {
                    CharSequence fragTitle = listItems.get(position).getTitle();
                    Fragment fragment = null;
                    fragment = new FieldGuideFragment();
                    ((MainActivity) activity).setTitle(fragTitle);
                    ((MainActivity) activity).displayView(fragment);
                }
            }
        });

        activity.setTitle(MainActivity.FIELD_GUIDE_POSITION);
        return rootView;

        /*btn_fieldGuide = (ImageButton) rootView.findViewById(R.id.Field_Guide_button);
        btn_fieldGuide.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(activity instanceof MainActivity)
                    ((MainActivity) activity).displayView(3);
            }
        });*/
    }

    /**
     * Initial Items in ListView
     * @param rootView
     * @param container
     */
    private void initList(View rootView, ViewGroup container) {
        String[] listTitles = getResources().getStringArray(R.array.field_guide_items);
        TypedArray listIcons = getResources().obtainTypedArray(R.array.field_guide_icons);
        String[] listDescriptions = getResources().getStringArray(R.array.field_guide_description);

        this.mDrawerList = (ListView) rootView.findViewById(R.id.fragment_list);
        this.context = container.getContext();
        this.listItems = new ArrayList<ListItem>();

        FieldGuideDatabaseHelper fieldGuideDBH = new FieldGuideDatabaseHelper(context);

        SQLiteDatabase fieldGuideDB = fieldGuideDBH.getReadableDatabase();

        Cursor dbCursor = fieldGuideDB.rawQuery("select binomial_name, code from species;", null);

        dbCursor.moveToFirst();

        for (int i = 0; i < dbCursor.getCount(); i++) {
//            Uri iconUri = Util.resIdToUri(context, R.drawable.(dbCursor.getString(2)));

            String imageName = dbCursor.getString(1);
//            Uri uri = Uri.fromFile(new File("assets/GlossaryImages/" + imageName));
//            Uri iconUri = Uri.parse("file:res/drawable/FORBS/"+imageName);
            Uri iconUri  = Uri.parse("android.resource://com.luminousmossboss.luminous/drawable/" + imageName.toLowerCase());
            listItems.add(new FGListItem(dbCursor.getString(0), iconUri));
            dbCursor.moveToNext();
        }

        dbCursor.close();

//        for (int i = 0; i < listTitles.length; i++) {
//            Uri iconUri = Util.resIdToUri(context,listIcons.getResourceId(i, -1) );
//            listItems.add(new FGListItem(listTitles[i], iconUri, listDescriptions[i]));
//        }
        listIcons.recycle();


        adapter = new FGListAdapter(context, listItems);
        mDrawerList.setAdapter(adapter);
    }
}
