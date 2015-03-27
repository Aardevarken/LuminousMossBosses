package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ListView;

import com.luminousmossboss.luminous.adapter.ObservationListAdapter;
import com.luminousmossboss.luminous.model.ListItem;
import com.luminousmossboss.luminous.model.Observation;

import java.io.File;
import java.util.ArrayList;

/**
 *
 * Created by Brian on 2/1/2015.
 */

public class ObservationListFragment extends Fragment{

    private Context context;
    private String mTitle;

    private ListView mDrawerList;

    private ObservationListAdapter adapter;
    private ArrayList<ListItem> listItems;
    private DbHandler db;

    public ObservationListFragment(){}

    //static method used for setting arguments;


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_listview, container, false);
        final Activity activity = getActivity();
        this.db = new DbHandler(activity);
        initList(rootView, container);



        //To be implemented for selecting individual observations
        this.mDrawerList.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if(activity instanceof MainActivity) {
                    CharSequence fragTitle = listItems.get(position).getTitle();
                    Fragment fragment = null;
                    fragment = ObservationFragment.newInstance((Observation)listItems.get(position));
                    ((MainActivity) activity).setTitle(fragTitle);
                    ((MainActivity) activity).displayView(fragment);
                }
            }
        });

        return rootView;
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
        Cursor cursor = db.getAllObservation();

        if (cursor.moveToFirst())
            do{
                Uri iconUri = Uri.fromFile(new File(cursor.getString(cursor.getColumnIndex(DbHandler.KEY_PHOTO_PATH))));
                String date= cursor.getString(cursor.getColumnIndex(DbHandler.KEY_TIME_TAKEN));
                listItems.add(new Observation("Silene", iconUri,date,0,0));

            }while(cursor.moveToNext());



        adapter = new ObservationListAdapter(context, listItems);
        mDrawerList.setAdapter(adapter);
    }
}
