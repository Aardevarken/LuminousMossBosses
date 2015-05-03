package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.database.Cursor;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;
import android.widget.RadioButton;

import com.luminousmossboss.luminous.adapter.ObservationListAdapter;
import com.luminousmossboss.luminous.model.ListItem;
import com.luminousmossboss.luminous.model.Observation;
import com.luminousmossboss.luminous.model.Separator;

import java.io.File;
import java.util.ArrayList;

import dialog.DeleteDialogFragment;
import info.hoang8f.android.segmented.SegmentedGroup;

/**
 *
 * Created by Brian on 2/1/2015.
 */

public class ObservationListFragment extends Fragment implements View.OnClickListener, BackButtonInterface{

    private Context context;
    private String mTitle;

    private ListView mDrawerList;
    private View rootView;
    private ViewGroup container;

    private ObservationListAdapter adapter;
    private ArrayList<ListItem> listItems;

    private ArrayList<Observation> selectedObservations;
    private ObservationDBHandler db;

    public static final int PENDING = 0;
    public static final int SYNCED = 1;
    private int syncedTab;

    private RadioButton mTabPending;
    private RadioButton mTabSynced;


    public ObservationListFragment(){}



    @Override
    public Boolean allowedBackPressed() {
        return true;
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        setHasOptionsMenu(true);
        rootView = inflater.inflate(R.layout.fragment_observationlist, container, false);

        // Handle Button Events
        mTabPending = (RadioButton) rootView.findViewById(R.id.tab_pending);
        mTabPending.setOnClickListener(this);
        mTabSynced = (RadioButton) rootView.findViewById(R.id.tab_synced);
        mTabSynced.setOnClickListener(this);

        syncedTab = PENDING;
        if(savedInstanceState != null)
        {
            syncedTab = savedInstanceState.getInt("Tab");
        }
        Bundle bundle = getArguments();
        if(bundle!=null)
        {
            syncedTab = bundle.getInt("Tab");
        }
        if (syncedTab == SYNCED)
        {
            mTabPending.setChecked(false);
            mTabSynced.setChecked(true);
        }
        else
        {
            mTabPending.setChecked(true);
            mTabSynced.setChecked(false);
        }

        this.container = container;
        final Activity activity = getActivity();
        this.db = new ObservationDBHandler(activity);
        initList(rootView, container, syncedTab);

        //For selecting individual observations in the list
        this.mDrawerList.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if(activity instanceof MainActivity && listItems.get(position) instanceof Observation) {
                    CharSequence fragTitle = listItems.get(position).getTitle();
                    Fragment fragment = null;
                    fragment = ObservationFragment.newInstance((Observation)listItems.get(position));
                    ((MainActivity) activity).setTitle(fragTitle);
                    ((MainActivity) activity).displayView(fragment);
                }
            }
        });

        // Set tab color
        SegmentedGroup tab_host = (SegmentedGroup) rootView.findViewById(R.id.tab_host);
        tab_host.setTintColor(getResources().getColor(R.color.fieldguide_button));

        activity.setTitle(MainActivity.OBSERVATION_LIST_POSITION);
        return rootView;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.observationlist_normal, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        final Activity activity = getActivity();
        switch (item.getItemId()) {
            case R.id.action_add_observation:
                ((MainActivity) activity).displayView(MainActivity.OBSERVATION_POSITION);
                break;
        }
        return true;
    }

    /**
     * Handle click events from tab elements
     */
    @Override
    public void onClick(View v) {
        switch (v.getId())
        {
            case R.id.tab_pending:
                syncedTab = PENDING;
                initList(rootView, container, PENDING);
                break;
            case R.id.tab_synced:
                syncedTab = SYNCED;
                initList(rootView, container, SYNCED);
                break;
        }
    }

    /**
     * Initial Items in ListView
     * @param rootView
     * @param container
     * @param status
     */
    private void initList(View rootView, ViewGroup container, int status) {


        this.mDrawerList = (ListView) rootView.findViewById(R.id.fragment_list);
        this.context = container.getContext();
        this.listItems = new ArrayList<ListItem>();
        ArrayList<ListItem> unidentifiedList = new ArrayList<ListItem>();
        unidentifiedList.add(new Separator(getString(R.string.separator_unidentified)));
        ArrayList<ListItem> sileneList = new ArrayList<ListItem>();
        sileneList.add(new Separator(getString(R.string.separator_silene)));
        ArrayList<ListItem> unknownList = new ArrayList<ListItem>();
        unknownList.add(new Separator(getString(R.string.separator_unknown)));

        //Cursor cursor = db.getAllObservation();
        Cursor cursor = db.getObservationBySyncStatus(status);
        int is_processed;
        int is_silene;
        int id;
        File file;
        if (cursor.moveToFirst())
            do{
               /* Uri iconUri = Uri.fromFile(new File(cursor.getString(cursor.getColumnIndex(ObservationDBHandler.KEY_PHOTO_PATH))));
                String date= cursor.getString(cursor.getColumnIndex(ObservationDBHandler.KEY_TIME_TAKEN));

                Double latitude = cursor.getDouble(cursor.getColumnIndex(ObservationDBHandler.KEY_LATITUDE));
                Double longitude = cursor.getDouble(cursor.getColumnIndex(ObservationDBHandler.KEY_LONGITUDE));

*/
                is_processed = cursor.getInt(cursor.getColumnIndex(ObservationDBHandler.KEY_PROCESSED_STATUS));
                is_silene = cursor.getInt(cursor.getColumnIndex(ObservationDBHandler.KEY_IS_SILENE));
                id = cursor.getInt(cursor.getColumnIndex(ObservationDBHandler.KEY_ID));
                file = new File(cursor.getString(cursor.getColumnIndex(ObservationDBHandler.KEY_PHOTO_PATH)));
                if(file.exists()) {
                    if (is_processed == 1) {
                        if (is_silene == 1)
                            sileneList.add(ObservationFactory.getObservation(id, getActivity()));
                        else
                            unknownList.add(ObservationFactory.getObservation(id, getActivity()));
                    }
                    else
                        unidentifiedList.add(ObservationFactory.getObservation(id, getActivity()));
                }
                else{
                    db.deleteObservation(cursor.getInt(cursor.getColumnIndex(ObservationDBHandler.KEY_ID)));
                }

            }while(cursor.moveToNext());
        db.close();
        if (unidentifiedList.size() > 1)
            listItems.addAll(unidentifiedList);
        if (sileneList.size() > 1)
            listItems.addAll(sileneList);
        if (unknownList.size() > 1)
            listItems.addAll(unknownList);

        adapter = new ObservationListAdapter(context, listItems);
        mDrawerList.setAdapter(adapter);
    }
    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt("Tab",syncedTab);




    }
}
