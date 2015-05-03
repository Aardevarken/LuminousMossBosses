package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.res.TypedArray;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
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
import com.luminousmossboss.luminous.model.Separator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import dialog.DeleteDialogFragment;

/**
 *
 * Created by Brian on 2/1/2015.
 */

public class FieldGuideListFragment extends Fragment implements View.OnClickListener, BackButtonInterface{

    private Context context;
    private String mTitle;

    private ListView mDrawerList;

    private FGListAdapter adapter;
    private ArrayList<ListItem> listItems;
    private static List<Integer> filteredIds;

    private static String filter_btn_title;
    private Button filter_btn;

    public FieldGuideListFragment(){}

    @Override
    public Boolean allowedBackPressed() {
        return true;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_fieldguide_list, container, false);

        initList(rootView, container);

        filter_btn = (Button) rootView.findViewById(R.id.filter_button);
        if (filter_btn_title != null)
            filter_btn.setText(filter_btn_title);
        filter_btn.setOnClickListener(this);

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

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.fieldguide, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        final Activity activity = getActivity();
        switch (item.getItemId()) {
            case R.id.action_filter:
                ((MainActivity) activity).displayView(new FiltersFragment());
                break;
        }
        return true;
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
        listIcons.recycle();
        refreshList();
    }

    private void refreshList() {
        this.listItems = new ArrayList<ListItem>();
        FieldGuideDBHandler fieldGuideDBH = FieldGuideDBHandler.getInstance(context);
        List<Integer> ids;
        if (filteredIds != null) {
            ids = filteredIds;
        }
        else
            ids = fieldGuideDBH.getIDs();
        HashMap<Integer, String> latinNames = fieldGuideDBH.getLatinNamesForIDs(ids);
        HashMap<Integer, String> commonNames = fieldGuideDBH.getCommonNamesForIDs(ids);
        HashMap<Integer, String> iconPaths = fieldGuideDBH.getIconPathsForIDs(ids);
        for (int i = 0; i < ids.size(); i++) {
            int id = ids.get(i);
            listItems.add(new FieldGuideItem(id, latinNames.get(id), iconPaths.get(id), commonNames.get(id)));
        }

        adapter = new FGListAdapter(context, listItems);
        mDrawerList.setAdapter(adapter);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.filter_button:
                Fragment fragment;
                if (filter_btn_title != null){
                    filteredIds = null;
                    filter_btn_title = null;
                    refreshList();
                    filter_btn.setText("Filters");
                }
                else {
                    fragment = new FiltersFragment();
                    ((MainActivity) getActivity()).displayView(fragment);
                }
        }
    }

    public static void setFilterIDS(List<Integer> ids) {
        filteredIds = ids;
    }

    public static void setFilterButtonTitle(String title) {
        filter_btn_title = title;
    }

}
