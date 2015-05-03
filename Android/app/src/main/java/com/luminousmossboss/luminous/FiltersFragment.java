package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.res.TypedArray;
import android.os.Bundle;
import android.os.Parcelable;
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
import com.luminousmossboss.luminous.adapter.GlossaryListAdapter;
import com.luminousmossboss.luminous.model.FieldGuideItem;
import com.luminousmossboss.luminous.model.GlossaryItem;
import com.luminousmossboss.luminous.model.ListItem;
import com.luminousmossboss.luminous.model.Separator;

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

    private GlossaryListAdapter adapter;
    private ArrayList<ListItem> listItems;

    private Button filter_btn;
    Parcelable state;

    public FiltersFragment(){}

    @Override
    public Boolean allowedBackPressed() {
        return true;
    }

    @Override
    public void onPause() {
        state = mDrawerList.onSaveInstanceState();
        super.onPause();
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
                    if (listItems.get(position) instanceof GlossaryItem) {
                        GlossaryItem item = (GlossaryItem) listItems.get(position);
                        String term = item.getTitle();
                        String category = item.getCategory();
                        List<Integer> ids = FieldGuideDBHandler.getInstance(context).filterFieldGuide(category, term);
                        FieldGuideListFragment.setFilterIDS(ids);
                        FieldGuideListFragment.setFilterButtonTitle("Current Filter - " + category + ": " + term + "\n (click to clear) ");
                        Fragment fragment = new FieldGuideListFragment();
                        ((MainActivity) activity).displayView(fragment);
                    }
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

        ArrayList<ListItem> flowercolorList = new ArrayList<ListItem>();
        flowercolorList.add(new Separator(getString(R.string.filter_flowercolor)));

        ArrayList<ListItem> inflorescenceList = new ArrayList<ListItem>();
        inflorescenceList.add(new Separator(getString(R.string.filter_inflorescence)));

        ArrayList<ListItem> flowershapeList = new ArrayList<ListItem>();
        flowershapeList.add(new Separator(getString(R.string.filter_flowershape)));

        ArrayList<ListItem> petalnumberList = new ArrayList<ListItem>();
        petalnumberList.add(new Separator(getString(R.string.filter_petalnumber)));

        ArrayList<ListItem> leafarrangementList = new ArrayList<ListItem>();
        leafarrangementList.add(new Separator(getString(R.string.filter_leafarrangement)));

        ArrayList<ListItem> leafshapefilterList = new ArrayList<ListItem>();
        leafshapefilterList.add(new Separator(getString(R.string.filter_leafshapefilter)));

        ArrayList<ListItem> habitatList = new ArrayList<ListItem>();
        habitatList.add(new Separator(getString(R.string.filter_habitat)));

        for (String flowercolor : fieldGuideDBH.getFlowerColorNames()){
            if (flowercolor.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(flowercolor, getString(R.string.filter_flowercolor), context);
            flowercolorList.add(item);
        }
        listItems.addAll(flowercolorList);

        for (String inflorescence : fieldGuideDBH.getInflorescenceNames()){
            if (inflorescence.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(inflorescence, getString(R.string.filter_inflorescence), context);
            inflorescenceList.add(item);
        }
        listItems.addAll(inflorescenceList);

        for (String flowershape : fieldGuideDBH.getFlowerShapeNames()){
            if (flowershape.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(flowershape, getString(R.string.filter_flowershape), context);
            flowershapeList.add(item);
        }
        listItems.addAll(flowershapeList);

        for (String petalnumber : fieldGuideDBH.getPetalNumberNames()){
            if (petalnumber.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(petalnumber, getString(R.string.filter_petalnumber), context);
            petalnumberList.add(item);
        }
        listItems.addAll(petalnumberList);

        for (String leafarrangement : fieldGuideDBH.getLeafArrangementNames()){
            if (leafarrangement.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(leafarrangement, getString(R.string.filter_leafarrangement), context);
            leafarrangementList.add(item);
        }
        listItems.addAll(leafarrangementList);

        for (String leafshapefilter : fieldGuideDBH.getLeafShapeFilterNames()){
            if (leafshapefilter.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(leafshapefilter, getString(R.string.filter_leafshapefilter), context);
            leafshapefilterList.add(item);
        }
        listItems.addAll(leafshapefilterList);

        for (String habitat : fieldGuideDBH.getHabitatNames()) {
            if (habitat.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(habitat, getString(R.string.filter_habitat), context);
            habitatList.add(item);
        }
        listItems.addAll(habitatList);

        listIcons.recycle();

        adapter = new GlossaryListAdapter(context, listItems);
        mDrawerList.setAdapter(adapter);
    }
}
