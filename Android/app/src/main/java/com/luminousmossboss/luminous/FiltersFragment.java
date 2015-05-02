package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.res.TypedArray;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;

import com.luminousmossboss.luminous.adapter.FGListAdapter;
import com.luminousmossboss.luminous.model.FieldGuideItem;
import com.luminousmossboss.luminous.model.ListItem;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 *
 * Created by Brian on 2/1/2015.
 */

public class FiltersFragment extends Fragment implements BackButtonInterface{

    private Context context;
    private String mTitle;

    private ListView mDrawerList;

    private FGListAdapter adapter;
    private ArrayList<ListItem> listItems;

    private Button filter_btn;

    public FiltersFragment(){}

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

        FieldGuideDBHandler fieldGuideDBH = FieldGuideDBHandler.getInstance(context);

        List<Integer> ids = fieldGuideDBH.getIDs();
        HashMap<Integer, String> latinNames = fieldGuideDBH.getLatinNames();
        HashMap<Integer, String> commonNames = fieldGuideDBH.getCommonNames();
        HashMap<Integer, String> iconPaths = fieldGuideDBH.getIconPaths();
        for (int i = 0; i < ids.size(); i++) {
//            listItems.add(fieldGuideDBH.getFGItemWithID(ids.get(i)));
            int id = ids.get(i);
            listItems.add(new FieldGuideItem(id, latinNames.get(id), iconPaths.get(id), commonNames.get(id)));
        }

        listIcons.recycle();

        adapter = new FGListAdapter(context, listItems);
        mDrawerList.setAdapter(adapter);
    }
}
