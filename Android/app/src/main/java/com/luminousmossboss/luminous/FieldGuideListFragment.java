package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.res.TypedArray;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;

import com.luminousmossboss.luminous.adapter.FGListAdapter;
import com.luminousmossboss.luminous.model.FieldGuideItem;
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
                    Fragment fragment = FieldGuideFragment.newInstance((FieldGuideItem) listItems.get(position));
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

        FieldGuideDBHandler fieldGuideDBH = new FieldGuideDBHandler(context);

        SQLiteDatabase fieldGuideDB = fieldGuideDBH.getReadableDatabase();

        Cursor dbCursor = fieldGuideDB.rawQuery("select id from species order by binomial_name;", null);

        if (dbCursor.moveToFirst()) {
            do {
                int id = dbCursor.getInt(0);
                listItems.add(new FieldGuideItem(id, context));
            } while (dbCursor.moveToNext());
        }



        dbCursor.close();

        listIcons.recycle();


        adapter = new FGListAdapter(context, listItems);
        mDrawerList.setAdapter(adapter);
    }
}
