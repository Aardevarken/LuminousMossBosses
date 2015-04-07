package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.luminousmossboss.luminous.adapter.DataListAdapter;
import com.luminousmossboss.luminous.model.DataItem;
import com.luminousmossboss.luminous.model.ListItem;
import com.luminousmossboss.luminous.model.Observation;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

import dialog.DeleteDialogFragment;

public class ObservationFragment extends Fragment implements OnClickListener, BackButtonInterface {

    private final static String OBSERVATION_KEY = "observation_key";


    private Button show_button;
    private Observation observation;

    public ObservationFragment()  { }

    public static ObservationFragment newInstance(Observation observation)
    {
        ObservationFragment fragment = new ObservationFragment();
        Bundle bundle = new Bundle();
        bundle.putSerializable(OBSERVATION_KEY, observation);
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

        setHasOptionsMenu(true);

        View rootView = inflater.inflate(R.layout.fragment_editobservation, container, false);

        ArrayList<ListItem> listItems = new ArrayList<ListItem>();

        ImageView imageView = (ImageView) rootView.findViewById(R.id.imageView);
        TextView title = (TextView) rootView.findViewById(R.id.title);
        ListView dataSet = (ListView) rootView.findViewById(R.id.listView);

        final Activity activity = getActivity();
        Bundle bundle = getArguments();
        this.observation = (Observation) bundle.getSerializable(OBSERVATION_KEY);
        imageView.setImageURI(observation.getIcon());
        Picasso.with(getActivity()).load(observation.getIcon()).resize(1365, 1024).centerCrop().onlyScaleDown().into(imageView);


        title.setText(observation.getTitle());
        listItems.add(new DataItem("Filename:", observation.getIcon().getLastPathSegment()));
        listItems.add(new DataItem("Date:", observation.getDate()));
        //filename.setText(observation.getIcon().getLastPathSegment());
        //date.setText(observation.getDate());

        listItems.add(new DataItem("Latitude:", observation.getLatitudeFormated()));
        listItems.add(new DataItem("Longitude:", observation.getLongitudeFormated()));

        DataListAdapter adapter = new DataListAdapter(container.getContext(), listItems);
        dataSet.setAdapter(adapter);

        // Handle Button Events
        Button sendButton = (Button) rootView.findViewById(R.id.button_send);
        sendButton.setOnClickListener(this);
        Button removeButton = (Button) rootView.findViewById(R.id.button_remove);
        removeButton.setOnClickListener(this);
        imageView.setOnClickListener(this);

        return rootView;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.observation, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_remove:
                new DeleteDialogFragment().show(getFragmentManager(), null);
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.button_send:
                new SendPostActivity(getActivity()).execute(observation);
                break;
            case R.id.button_remove:
                DeleteDialogFragment ddf = new DeleteDialogFragment();
                ddf.show(getFragmentManager(), null);
                if (ddf.getConfirmation()) {
                    DbHandler db = new DbHandler(getActivity());
                    db.deleteObservation(observation.getIcon().getPath());
                    MainActivity activity = (MainActivity) getActivity();
                    activity.displayView(MainActivity.OBSERVATION_LIST_POSITION);
                }
                break;
            case R.id.imageView:
                IdActivity idActivity = new IdActivity(getActivity());
                idActivity.execute(observation.getIcon().getPath());
                break;
        }
    }
}
