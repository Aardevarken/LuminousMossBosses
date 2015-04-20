package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.luminousmossboss.luminous.adapter.DataListAdapter;
import com.luminousmossboss.luminous.model.DataItem;
import com.luminousmossboss.luminous.model.FieldGuideItem;
import com.luminousmossboss.luminous.model.ListItem;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

public class FieldGuideFragment extends Fragment implements BackButtonInterface {

    private FieldGuideItem fgitem;
    private final static String FGITEM_KEY = "fgitem_key";

    public FieldGuideFragment(){}


    public static FieldGuideFragment newInstance(FieldGuideItem item)
    {
        FieldGuideFragment fragment = new FieldGuideFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable(FGITEM_KEY, item);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public Boolean allowedBackPressed() {
        return true;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View rootView = inflater.inflate(R.layout.fragment_fieldguide, container, false);
        ArrayList<ListItem> listItems = new ArrayList<>();
        final Activity activity = getActivity();
        Bundle bundle = getArguments();
        setHasOptionsMenu(true);

        ImageView imageView = (ImageView) rootView.findViewById(R.id.imageView);
        TextView title = (TextView) rootView.findViewById(R.id.title);
        ListView dataSet = (ListView) rootView.findViewById(R.id.listView);
        FieldGuideDBHandler fgDBHelper = FieldGuideDBHandler.getInstance(container.getContext());
        this.fgitem = fgDBHelper.getFGItemWithID(((FieldGuideItem) bundle.getSerializable(FGITEM_KEY)).getId());
        imageView.setImageURI(fgitem.getIcon());
        Picasso.with(getActivity()).load(fgitem.getIcon()).into(imageView);


        title.setText(fgitem.getTitle());
        String[] columns = fgitem.getColumns();
        for (int i= 0; i < columns.length; i++) {
            listItems.add(new DataItem(columns[i] + ":", fgitem.getProperty(columns[i])));
        }

        DataListAdapter adapter = new DataListAdapter(container.getContext(), listItems);

        dataSet.setAdapter(adapter);


        return rootView;
    }



}