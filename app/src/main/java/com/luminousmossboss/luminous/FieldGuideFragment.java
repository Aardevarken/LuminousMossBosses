package com.luminousmossboss.luminous;

import android.app.Fragment;
import android.content.Context;
import android.content.res.TypedArray;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.luminousmossboss.luminous.adapter.FGListAdapter;
import com.luminousmossboss.luminous.model.FGListItem;
import com.luminousmossboss.luminous.model.ListItem;

import java.util.ArrayList;

/**
 *
 * Created by Brian on 2/1/2015.
 */

public class FieldGuideFragment extends Fragment{

    private Context context;
    private String mTitle;

    private ListView mDrawerList;

    private FGListAdapter adapter;
    private ArrayList<ListItem> listItems;

    public FieldGuideFragment(){}

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_listview, container, false);

        initList(rootView, container);

        return rootView;
    }

    /**
     * Initial Items in ListView
     * @param rootView
     * @param container
     */
    private void initList(View rootView, ViewGroup container) {
        String[] listTitles = getResources().getStringArray(R.array.field_guide_items);
        TypedArray listIcons = getResources().obtainTypedArray(R.array.field_guide_icons);

        mDrawerList = (ListView) rootView.findViewById(R.id.fragment_list);

        listItems = new ArrayList<ListItem>();

        for (int i = 0; i < listTitles.length; i++) {
            listItems.add(new FGListItem(listTitles[i], listIcons.getResourceId(i, -1)));
        }
        listIcons.recycle();

        context = container.getContext();
        adapter = new FGListAdapter(context, listItems);
        mDrawerList.setAdapter(adapter);
    }
}
