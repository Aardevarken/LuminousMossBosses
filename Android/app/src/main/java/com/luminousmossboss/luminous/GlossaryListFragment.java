package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.res.TypedArray;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListView;

import com.luminousmossboss.luminous.adapter.GlossaryListAdapter;
import com.luminousmossboss.luminous.model.GlossaryItem;
import com.luminousmossboss.luminous.model.ListItem;
import com.luminousmossboss.luminous.model.Separator;

import java.util.ArrayList;

/**
 *
 * Created by Brian on 2/1/2015.
 */

public class GlossaryListFragment extends Fragment implements BackButtonInterface{

    private Context context;
    private String mTitle;

    private ListView mDrawerList;

    private GlossaryListAdapter adapter;
    private ArrayList<ListItem> listItems;

    private Button filter_btn;

    public GlossaryListFragment(){}

    @Override
    public Boolean allowedBackPressed() {
        return true;
    }

    @Override
    public void onPause(){
        super.onPause();
        GlossaryItem.clearCache();
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_listview, container, false);

        initList(rootView, container);

        final Activity activity = getActivity();

        activity.setTitle(MainActivity.GLOSSARY_POSITION);
        return rootView;
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

        this.mDrawerList = (ListView) rootView.findViewById(R.id.fragment_list);
        this.context = container.getContext();
        this.listItems = new ArrayList<ListItem>();

        TypedArray listIcons = getResources().obtainTypedArray(R.array.field_guide_icons);

        FieldGuideDBHandler fieldGuideDBH = FieldGuideDBHandler.getInstance(context);



        ArrayList<ListItem> flowercolorList = new ArrayList<ListItem>();
        flowercolorList.add(new Separator(getString(R.string.glossary_flowercolor)));

        ArrayList<ListItem> inflorescenceList = new ArrayList<ListItem>();
        inflorescenceList.add(new Separator(getString(R.string.glossary_inflorescence)));

        ArrayList<ListItem> flowershapeList = new ArrayList<ListItem>();
        flowershapeList.add(new Separator(getString(R.string.glossary_flowershape)));

        ArrayList<ListItem> leafarrangementList = new ArrayList<ListItem>();
        leafarrangementList.add(new Separator(getString(R.string.glossary_leafarrangement)));


        ArrayList<ListItem> leafshapeList = new ArrayList<ListItem>();
        leafshapeList.add(new Separator(getString(R.string.glossary_leafshape)));

        ArrayList<ListItem> habitatList = new ArrayList<ListItem>();
        habitatList.add(new Separator(getString(R.string.glossary_habitat)));

        for (String flowercolor : fieldGuideDBH.getFlowerColorNames()){
            if (flowercolor.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(flowercolor, getString(R.string.glossary_flowercolor), context);
            flowercolorList.add(item);
        }
        listItems.addAll(flowercolorList);

        for (String inflorescence : fieldGuideDBH.getInflorescenceNames()){
            if (inflorescence.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(inflorescence, getString(R.string.glossary_inflorescence), context);
            inflorescenceList.add(item);
        }
        listItems.addAll(inflorescenceList);

        for (String flowershape : fieldGuideDBH.getFlowerShapeNames()){
            if (flowershape.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(flowershape, getString(R.string.glossary_flowershape), context);
            flowershapeList.add(item);
        }
        listItems.addAll(flowershapeList);

        for (String leafarrangement : fieldGuideDBH.getLeafArrangementNames()){
            if (leafarrangement.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(leafarrangement, getString(R.string.glossary_leafarrangement), context);
            leafarrangementList.add(item);
        }
        listItems.addAll(leafarrangementList);

        for (String leafshape : fieldGuideDBH.getLeafShapeNames()){
            if (leafshape.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(leafshape, getString(R.string.glossary_leafshape), context);
            leafshapeList.add(item);
        }
        listItems.addAll(leafshapeList);

        for (String habitat : fieldGuideDBH.getHabitatNames()) {
            if (habitat.equals("other")) continue;
            GlossaryItem item = GlossaryItem.getGlossaryItem(habitat, getString(R.string.glossary_habitat), context);
            habitatList.add(item);
        }
        listItems.addAll(habitatList);

        adapter = new GlossaryListAdapter(context, listItems);
        mDrawerList.setAdapter(adapter);

        listIcons.recycle();
    }
}
