package com.luminousmossboss.luminous;

import android.app.Activity;
import android.app.DialogFragment;
import android.app.Fragment;
import android.database.Cursor;
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
import dialog.DialogListener;

public class ObservationFragment extends Fragment implements OnClickListener, BackButtonInterface, DialogListener {

    private final static String OBSERVATION_KEY = "observation_key";


    private Button sendButton;
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
        Picasso.with(getActivity()).load(observation.getIcon()).resize(1365, 1024).centerCrop().into(imageView);


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
        sendButton = (Button) rootView.findViewById(R.id.button_context);
        sendButton.setOnClickListener(this);
        imageView.setOnClickListener(this);

        //Check if Buttons should be visible
        ObservationDBHandler db = new ObservationDBHandler(getActivity());
        Cursor cursor = db.getObservationById(observation.getId());
        cursor.moveToFirst();
        if(cursor.getInt(cursor.getColumnIndex(ObservationDBHandler.KEY_SYNCED_STATUS)) != 0)
        {
            sendButton.setVisibility(View.GONE);
        }

        return rootView;
    }

    @Override
    public void onDialogPositiveClick(DialogFragment dialog) {
        ObservationDBHandler db = new ObservationDBHandler(getActivity());
        db.deleteObservation(observation.getId());
        MainActivity activity = (MainActivity) getActivity();
        activity.displayView(MainActivity.OBSERVATION_LIST_POSITION);
    }

    @Override
    public void onDialogNegativeClick(DialogFragment dialog) {
        // do something
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
                DeleteDialogFragment dialog = DeleteDialogFragment.getInstance(observation.getId());
                dialog.show(getActivity().getFragmentManager(), "dialog");
                //new DeleteDialogFragment().show(getFragmentManager(), null);
                break;
        }
        return true;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.button_context:
                new SendPostActivity(getActivity(), observation.getId(), sendButton).execute(observation);
                break;
            case R.id.imageView:
                IdActivity idActivity = new IdActivity(getActivity(), observation.getId());
                idActivity.execute(observation.getIcon().getPath());
                break;
        }
    }
}
