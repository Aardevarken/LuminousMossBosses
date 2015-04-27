package com.luminousmossboss.luminous;

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
import android.widget.ProgressBar;
import android.widget.TextView;

import com.luminousmossboss.luminous.adapter.DataListAdapter;
import com.luminousmossboss.luminous.model.DataItem;
import com.luminousmossboss.luminous.model.ListItem;
import com.luminousmossboss.luminous.model.Observation;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.HashMap;

import dialog.DeleteDialogFragment;
import dialog.DialogListener;

public class ObservationFragment extends Fragment implements OnClickListener, BackButtonInterface, DialogListener {

    private final static String OBSERVATION_KEY = "observation_key";
    //flags for what the Button should do
    private final int IDENTIFY_CONTEXT = 0;
    private final int SEND_CONTEXT = 1;
    private static HashMap<Integer, IdActivity> runningActivities = new HashMap<>();

    private int buttonContext;

    public Button getSendButton() {
        return sendButton;
    }

    public ProgressBar getProgressBar() {
        return progressBar;
    }

    private Button sendButton;
    private Observation observation;
    private ProgressBar progressBar;

    public ObservationFragment()  {
    }

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

//        final Activity activity = getActivity();
        Bundle bundle = getArguments();
        this.observation = (Observation) bundle.getSerializable(OBSERVATION_KEY);
//        imageView.setImageURI(observation.getIcon());
        Picasso.with(getActivity()).load(observation.getIcon()).fit().centerInside().into(imageView);


        title.setText(observation.getTitle());
        listItems.add(new DataItem("Filename:", observation.getIcon().getLastPathSegment()));
        listItems.add(new DataItem("Date:", observation.getDate()));
        //filename.setText(observation.getIcon().getLastPathSegment());
        //date.setText(observation.getDate());

        listItems.add(new DataItem("Latitude:", observation.getLatitudeFormated()));
        listItems.add(new DataItem("Longitude:", observation.getLongitudeFormated()));
        listItems.add(new DataItem("Location Accuracy:", Float.toString(observation.getAccuracy())+"m"));

        DataListAdapter adapter = new DataListAdapter(container.getContext(), listItems);
        dataSet.setAdapter(adapter);

        // Handle Button Events

        sendButton = (Button) rootView.findViewById(R.id.button_context);
        sendButton.setOnClickListener(this);
        progressBar = (ProgressBar) rootView.findViewById(R.id.progressBar);
        //imageView.setOnClickListener(this);

        //Check if Buttons should be visible
        ObservationDBHandler db = new ObservationDBHandler(getActivity());
        Cursor cursor = db.getObservationById(observation.getId());
        cursor.moveToFirst();
        if(cursor.getInt(cursor.getColumnIndex(ObservationDBHandler.KEY_PROCESSED_STATUS)) == 0 )
        {
            sendButton.setText("Identify");
            sendButton.setCompoundDrawables(null,null,null,null);
            buttonContext = IDENTIFY_CONTEXT;
        }
        else if(cursor.getInt(cursor.getColumnIndex(ObservationDBHandler.KEY_SYNCED_STATUS)) == 0 ) {
            buttonContext = SEND_CONTEXT;
        }
        if (cursor.getInt(cursor.getColumnIndex(ObservationDBHandler.KEY_SYNCED_STATUS)) != 0 || observation.isBeingProcessed())
        {
            sendButton.setEnabled(false);
            sendButton.setVisibility(View.GONE);
        }
        if ( observation.isBeingProcessed())
        {
            progressBar.setVisibility(View.VISIBLE);
            sendButton.setEnabled(false);
            sendButton.setVisibility(View.GONE);
            runningActivities.get(observation.getId()).attachFragment(this);
        }
        if (observation.isSent() && buttonContext == SEND_CONTEXT) {
            sendButton.setEnabled(false);
            sendButton.setVisibility(View.GONE);
        }
        cursor.close();
        db.close();

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
                if(buttonContext == IDENTIFY_CONTEXT)
                {
                    if (!observation.isBeingProcessed() && !observation.isHasBeenProcceced()) {
                        IdActivity idActivity = new IdActivity(getActivity(), observation.getId(), this);
                        runningActivities.put(observation.getId(), idActivity);
                        idActivity.execute(observation.getIcon().getPath());
                        buttonContext = SEND_CONTEXT;
                    }
                    break;
                }
                else
                {
                    if (!observation.isSent())
                        new SendPostActivity(getActivity(), observation, sendButton).execute(observation);
                    break;
                }


        }
    }

    public void attachIdActivity (IdActivity activity) {
        Bundle bundle = getArguments();
        this.observation = (Observation) bundle.getSerializable(OBSERVATION_KEY);
        runningActivities.put(observation.getId(), activity);
    }

    public void detachIdActivity() {
        runningActivities.remove(observation.getId());
    }

    public void setButtonContextSend() {
        buttonContext = SEND_CONTEXT;
    }

}
